//---------------------------------------------------------------------------
// Copyright 2013 PwC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------

package us.pwc.vista.eclipse.server.command;

import gov.va.med.foundations.adapter.cci.VistaLinkConnection;
import gov.va.med.iss.connection.actions.VistaConnection;
import gov.va.med.iss.connection.utilities.ConnectionUtilities;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.resources.IContainer;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Path;

import us.pwc.vista.eclipse.core.VistACorePrefs;
import us.pwc.vista.eclipse.core.helper.MessageDialogHelper;
import us.pwc.vista.eclipse.server.Messages;
import us.pwc.vista.eclipse.server.VistAServerPlugin;
import us.pwc.vista.eclipse.server.core.CommandResult;
import us.pwc.vista.eclipse.server.core.LoadRoutineEngine;
import us.pwc.vista.eclipse.server.core.MServerRoutine;
import us.pwc.vista.eclipse.server.core.PreferencesPathResolver;
import us.pwc.vista.eclipse.server.core.RootPathResolver;
import us.pwc.vista.eclipse.server.core.VFPackageRepo;
import us.pwc.vista.eclipse.server.core.VFPathResolver;
import us.pwc.vista.eclipse.server.dialog.CustomDialogHelper;
import us.pwc.vista.eclipse.server.dialog.InputDialogHelper;
import us.pwc.vista.eclipse.server.preferences.VistAServerPrefs;
import us.pwc.vista.eclipse.server.preferences.NewFileFolderScheme;
import us.pwc.vista.eclipse.server.resource.FileSearchVisitor;

public class LoadMRoutine extends AbstractHandler {
	private static IProject getProject(String projectName) {
		try {
			IWorkspace workspace = ResourcesPlugin.getWorkspace();
			IWorkspaceRoot root = workspace.getRoot();
			IProject project = root.getProject(projectName);
			if (! project.exists()) {
				project.create(new NullProgressMonitor());
			}
			if (! project.isOpen()) {
				project.open(new NullProgressMonitor());
			}
			return project;
		} catch (CoreException ce) {
			String message = Messages.bind(Messages.UNABLE_GET_PROJECT, projectName, ce.getMessage());
			MessageDialogHelper.logAndShow(VistAServerPlugin.PLUGIN_ID, message, ce);
			return null;
		} catch (Throwable t) {
			MessageDialogHelper.logAndShow(VistAServerPlugin.PLUGIN_ID, t);
			return null;
		}
	}
	
	private static IFile getExistingFileHandle(IProject project, String routineName) throws CoreException {
		String backupDirectory = VistACorePrefs.getServerBackupDirectory(project);
		FileSearchVisitor visitor = new FileSearchVisitor(routineName + ".m", backupDirectory);
		project.accept(visitor, 0);
		return visitor.getFile();
	}
	
	public static IFile getNewFileHandle(IProject project, String routineName) throws CoreException {		
		NewFileFolderScheme locationScheme = VistAServerPrefs.getNewFileFolderScheme(project);
		switch (locationScheme) {
		case NAMESPACE_SPECIFIED:
			IResource resource = project.findMember("Packages.csv");
			if (resource != null) {
				IFile file = (IFile) resource;
				VFPathResolver vpr = new VFPathResolver(new VFPackageRepo(file));
				return vpr.getFileHandle(project, routineName);
			} else {
				RootPathResolver rpr = new RootPathResolver();
				rpr.getFileHandle(project, routineName);
			}			
		case PROJECT_ROOT:
			boolean serverNameToFolder = VistAServerPrefs.getAddServerNameSubfolder(project);
			int namespaceDigits = VistAServerPrefs.getAddNamespaceCharsSubfolder(project);
			String serverName = serverNameToFolder ? VistaConnection.getPrimaryServerName() : null;
			PreferencesPathResolver ppr = new PreferencesPathResolver(serverName, namespaceDigits);
			return ppr.getFileHandle(project, routineName);
		default:
			IContainer container = CustomDialogHelper.selectWritableFolder(project);
			if (container != null) {
				IPath path = new Path(routineName + ".m");
				return container.getFile(path);
			} else {
				return null;
			}
		}
	}

	private static IFile getFileHandle(IProject project, String routineName) throws ExecutionException {
		try {
			IFile fileHandle = getExistingFileHandle(project, routineName);
			if (fileHandle == null) {
				return getNewFileHandle(project, routineName);
			}
			return fileHandle;
		} catch (CoreException coreException) {
			String message = Messages.bind(Messages.UNABLE_GET_HANDLE, routineName);
			throw new ExecutionException(message, coreException);
		}
	}
		
	@Override
	public Object execute(final ExecutionEvent event) throws ExecutionException {
		VistaLinkConnection connection = VistaConnection.getConnection();
		if (connection == null) {
			return null;
		}
		
		String title = Messages.bind2(Messages.LOAD_M_RTN_DLG_TITLE, ConnectionUtilities.getServer(), ConnectionUtilities.getPort(), ConnectionUtilities.getProject());
		String routineName = InputDialogHelper.getRoutineName(title);
		if (routineName == null) {
			return null;
		}
		
		String projectName = VistaConnection.getPrimaryProject();
		IProject project = getProject(projectName);
		if (project == null) {
			return null;
		}
		
		IFile fileHandle = getFileHandle(project, routineName);
		if (fileHandle == null) {
			return null;
		}
		
		CommandResult<MServerRoutine> result = LoadRoutineEngine.loadRoutine(connection, fileHandle);
		IStatus status = result.getStatus();		
		if (status.getSeverity() != IStatus.OK) {
			MessageDialogHelper.logAndShow(Messages.LOAD_MSG_TITLE, status);			
		}
		if (status.getSeverity() != IStatus.ERROR) {
			IFile file = result.getResultObject().getFileHandle();
			CommandCommon.openEditor(event, file);
		}
		return null;
	}
}