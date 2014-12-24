package com.pwc.us.rgi.util;

import static org.junit.Assert.*;

import org.junit.Assert;
import org.junit.Test;

import com.pwc.us.rgi.m.token.MVersion;
import com.pwc.us.rgi.vista.tools.CLIParams;

public class CLIParamsTest {
	private void testMVersionCase(String[] args, MVersion version) {
		try {
			CLIParams params = CLIParamMgr.parse(CLIParams.class, args);
			Assert.assertEquals(params.mVersion, version);
		} catch (Throwable t) {
			fail("Exception: " + t.getMessage());			
		}				
	}
		
	@Test
	public void testMVersion() {
		this.testMVersionCase(new String[]{"pos"}, MVersion.CACHE);
		this.testMVersionCase(new String[]{"-mv", "cache", "pos"}, MVersion.CACHE);
		this.testMVersionCase(new String[]{"-mv", "ansi_std_95", "pos"}, MVersion.ANSI_STD_95);
		this.testMVersionCase(new String[]{"--mversion", "cache", "pos"}, MVersion.CACHE);
		this.testMVersionCase(new String[]{"--mversion", "ansi_std_95", "pos"}, MVersion.ANSI_STD_95);
	}
}
