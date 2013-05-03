package gov.va.mumps.debug.ui.console;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.KeyListener;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Device;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IActionBars;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.part.IPageBookViewPage;
import org.eclipse.ui.part.IPageSite;

//REFER to here for more info on how to implement an IPageBookViewPage:
//http://grepcode.com/file/repository.grepcode.com/java/eclipse.org/4.2/org.eclipse.ui/console/3.5.100/org/eclipse/ui/console/TextConsolePage.java#TextConsolePage.%3Cinit%3E%28org.eclipse.ui.console.TextConsole%2Corg.eclipse.ui.console.IConsoleView%29
public class MDevConsolePage implements IPageBookViewPage, KeyListener {
	
	private MDevConsole console;
	private StyledText textWidget;
	private IPageSite pageSite;
	
	public MDevConsolePage(MDevConsole console) {
		super();
		
		this.console = console;
	}

	@Override
	public void createControl(Composite parent) {
		textWidget = new StyledText(parent, SWT.V_SCROLL);
		textWidget.setText("");
		Device device = Display.getCurrent();
		textWidget.setBackground(new Color(device, 0, 0, 0));
		textWidget.setEditable(false);
		textWidget.setForeground(new Color(device, 255, 255, 255));
		FontData fd = new FontData("Courier New", 10, 0);
		textWidget.setFont(new Font(device, fd)); //TODO: add backup true type fonts/test for other supported OS'es
		textWidget.addKeyListener(this);
		
		
		//NOTE: can create actions and add them to the toolbar here.	
	}

	@Override
	public void dispose() {
		textWidget.removeKeyListener(this);
		textWidget.dispose();
	}

	@Override
	public Control getControl() {
		return textWidget;
	}

	@Override
	public void setActionBars(IActionBars actionBars) {
	}

	@Override
	public void setFocus() {
		if (textWidget != null) {
			textWidget.setFocus();
		}
	}

	@Override
	public IPageSite getSite() {
		return pageSite;
	}

	@Override
	public void init(IPageSite pageSite) throws PartInitException {
		this.pageSite = pageSite;
	}

	
	//key listener: TODO: its large enough to move toits own class
	char[] keyBuffer = new char[2048]; //TODO: refactor this to a new class that is reusable
	int bufferPos = -1;
	
	@Override
	public void keyPressed(KeyEvent ke) {
		if (ke.character != 0 && console.isAcceptingUserInput())
			keyBuffer[++bufferPos] = ke.character;
	}

	@Override
	public void keyReleased(KeyEvent ke) { //TODO: this could be improved slightly, right now all the keys in the buffer appear on screen at once. it makes more sense to put them onto the screen sooner
		StringBuffer contents = new StringBuffer();
		for (int i = 0; i <= bufferPos; i++)
			contents.append(keyBuffer[i]);
		textWidget.setText(textWidget.getText() + contents.toString());
		keyBuffer = new char[2048];
		bufferPos = -1;
		
		//update cursor to end pos
		//textWidget.setCaretOffset(textWidget.getText().length());

		//if (ke.keyCode == ) handle page up, page down.
	}
	
}
