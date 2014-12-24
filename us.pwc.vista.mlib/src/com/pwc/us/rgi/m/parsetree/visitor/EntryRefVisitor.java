package com.pwc.us.rgi.m.parsetree.visitor;

import java.util.ArrayList;
import java.util.List;

import com.pwc.us.rgi.m.parsetree.AtomicDo;
import com.pwc.us.rgi.m.parsetree.ErrorNode;
import com.pwc.us.rgi.m.parsetree.FanoutLabel;
import com.pwc.us.rgi.m.parsetree.FanoutRoutine;
import com.pwc.us.rgi.m.parsetree.Visitor;
import com.pwc.us.rgi.m.parsetree.data.EntryId;

public class EntryRefVisitor extends Visitor {	
	private List<EntryId> entryTags = new ArrayList<EntryId>();
	private String label;
	private String routine;
	
	@Override
	protected void visitErrorNode(ErrorNode error) {
		super.visitErrorNode(error);
	}

	@Override
	protected void visitFanoutLabel(FanoutLabel label) {
		super.visitFanoutLabel(label);
		this.label = label.getValue();
		//System.out.println("LBL: " + label.getValue());
	}

	@Override
	protected void visitFanoutRoutine(FanoutRoutine routine) { //this is not visited if the call is to a local tag (ie: D TAG)
		super.visitFanoutRoutine(routine);
		this.routine = routine.getName();
		//System.out.println("RTN: " + routine.getName());
	}
	
	@Override
	protected void visitAtomicDo(AtomicDo atomicDo) {
		reset();
		super.visitAtomicDo(atomicDo);
		updateEntryTags();
	}
	
	private void reset() {
		label = null;
		routine = null;
	}

	private void updateEntryTags() {
		entryTags.add(new EntryId(routine, label));
	}
	
	public List<EntryId> getEntryTags() {
		return entryTags;
	}
}


