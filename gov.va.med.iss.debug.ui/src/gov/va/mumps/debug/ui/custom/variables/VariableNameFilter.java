package gov.va.mumps.debug.ui.custom.variables;

import gov.va.mumps.debug.xtdebug.vo.VariableVO;

import org.eclipse.jface.viewers.Viewer;
import org.eclipse.jface.viewers.ViewerFilter;

public class VariableNameFilter extends ViewerFilter {
	
	private String pattern;
	
	public VariableNameFilter() {
	}
	
	@Override
	public boolean select(Viewer viewer, Object parentElement, Object element) {
		if (pattern == null || pattern.length() == 0)
			return true;
		
		if (((VariableVO)element).getName().startsWith(pattern.toUpperCase()))
			return true;
		
		return false;

	}

	public void setPattern(String pattern) {
		this.pattern = pattern;
	}

}
