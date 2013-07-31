package gov.va.med.iss.meditor.dialog;

import gov.va.med.iss.meditor.MEditorPlugin;
import gov.va.med.iss.meditor.Messages;

import org.eclipse.ui.console.ConsolePlugin;
import org.eclipse.ui.console.IConsole;
import org.eclipse.ui.console.IConsoleManager;
import org.eclipse.ui.console.MessageConsole;
import org.eclipse.ui.console.MessageConsoleStream;

public class MessageConsoleHelper {
	private static MessageConsole findConsole(IConsoleManager consoleManager, String name) {
		IConsole[] consoles = consoleManager.getConsoles();
		for (IConsole console : consoles) {
			if (name.equals(console.getName())) {
				return (MessageConsole) console;
			}
		}
		MessageConsole newConsole = new MessageConsole(name, null);
		consoleManager.addConsoles(new IConsole[] {newConsole});
		return newConsole;
	}

	public static void writeToConsole(String text) {
		try {
			ConsolePlugin plugin = ConsolePlugin.getDefault();
			IConsoleManager consoleManager = plugin.getConsoleManager();
			MessageConsole console = findConsole(consoleManager, "MEditorConsole");
			console.clearConsole();
			MessageConsoleStream out = console.newMessageStream();
			out.print(text);
			out.close();
			consoleManager.showConsoleView(console);
		} catch (Throwable t) {
			String message = Messages.bind(Messages.WRITE_TO_CONSOLE_ERROR, t.getMessage());
			MEditorPlugin.getDefault().logError(message);
			MEditorPlugin.getDefault().logInfo(text);
		}		
	}
}