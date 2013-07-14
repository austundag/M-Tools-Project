package gov.va.med.iss.meditor.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class RunCommand {

    public static void main(String args[]) {

        @SuppressWarnings("unused")
		String s = null;

	    // run the Unix "ps -ef" command
            // using the Runtime exec method:
            //Process p = Runtime.getRuntime().exec("C:\\Program Files\\Internet Explorer\\iexplore c:\\Documents and Settings\\vhaisfiveyj\\My Documents\\091130 html test1.htm");
        	String filename = "c:\\Documents and Settings\\vhaisfiveyj\\My Documents\\091130 html test1.htm";
        	runCommand(filename);
    }
    
    @SuppressWarnings("unused")
	static void runCommand(String filename) {
    	try {
            Process p = Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler "+filename);
            
            BufferedReader stdInput = new BufferedReader(new 
                 InputStreamReader(p.getInputStream()));

            BufferedReader stdError = new BufferedReader(new 
                 InputStreamReader(p.getErrorStream()));

        }
        catch (IOException e) {
            System.out.println("exception happened - here's what I know: ");
            e.printStackTrace();
        }
    }
}
