/*
 * Copyright (c) 2015 Memorial Sloan-Kettering Cancer Center.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY, WITHOUT EVEN THE IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS
 * FOR A PARTICULAR PURPOSE. The software and documentation provided hereunder
 * is on an "as is" basis, and Memorial Sloan-Kettering Cancer Center has no
 * obligations to provide maintenance, support, updates, enhancements or
 * modifications. In no event shall Memorial Sloan-Kettering Cancer Center be
 * liable to any party for direct, indirect, special, incidental or
 * consequential damages, including lost profits, arising out of the use of this
 * software and its documentation, even if Memorial Sloan-Kettering Cancer
 * Center has been advised of the possibility of such damage.
 */

/*
 * This file is part of cBioPortal.
 *
 * cBioPortal is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package org.mskcc.cbio.portal.scripts;

import java.io.*;
import java.util.Date;

import joptsimple.*;

import org.mskcc.cbio.portal.dao.*;
import org.mskcc.cbio.portal.model.*;
import org.mskcc.cbio.portal.util.*;

/**
 * Import 'profile' files that contain data matrices indexed by gene, case. 
 * <p>
 * @author ECerami
 * @author Arthur Goldberg goldberg@cbio.mskcc.org
 */
public class ImportProfileData{

    private static String usageLine;
    private static OptionParser parser;

    private static void quit(String msg)
    {
        if( null != msg ){
            System.err.println( msg );
        }
        System.err.println( usageLine );
        try {
            parser.printHelpOn(System.err);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

   public static void main(String[] args) throws Exception {
       Date start = new Date();

       usageLine = "Import 'profile' files that contain data matrices indexed by gene, case.\n" +
       		"command line usage for importProfileData:";
       /*
        * usage:
        * --data <data_file.txt> --meta <meta_file.txt> --loadMode [directLoad|bulkLoad (default)] "
        * 
        * nb: an extra --noprogress option can be given to avoid the messages regarding memory usage and % complete
        */

       // using a real options parser, helps avoid bugs
       parser = new OptionParser();
       parser.accepts("noprogress", "this option can be given to avoid the messages regarding memory usage and % complete");
       OptionSpec<Void> help = parser.accepts( "help", "print this help info" );
       OptionSpec<String> data = parser.accepts( "data",
               "profile data file" ).withRequiredArg().describedAs( "data_file.txt" ).ofType( String.class );
       OptionSpec<String> meta = parser.accepts( "meta",
               "meta (description) file" ).withRequiredArg().describedAs( "meta_file.txt" ).ofType( String.class );
       OptionSpec<String> loadMode = parser.accepts( "loadMode", "direct (per record) or bulk load of data" )
          .withRequiredArg().describedAs( "[directLoad|bulkLoad (default)]" ).ofType( String.class );
       OptionSet options = null;
      try {
         options = parser.parse( args );
         //exitJVM = !options.has(returnFromMain);
      } catch (OptionException e) {
          quit( e.getMessage() );
      }
      
      if( options.has( help ) ){
          quit( "" );
      }
       
       File dataFile = null;
       if( options.has( data ) ){
          dataFile = new File( options.valueOf( data ) );
       }else{
           quit( "'data' argument required.");
       }

       File descriptorFile = null;
       if( options.has( meta ) ){
          descriptorFile = new File( options.valueOf( meta ) );
       }else{
           quit( "'meta' argument required.");
       }
       
       MySQLbulkLoader.bulkLoadOn();
       if( options.has( loadMode ) ){
          String actionArg = options.valueOf( loadMode );
          if (actionArg.equalsIgnoreCase("directLoad")) {
             MySQLbulkLoader.bulkLoadOff();
          } else if (actionArg.equalsIgnoreCase( "bulkLoad" )) {
             MySQLbulkLoader.bulkLoadOn();
          } else {
              quit( "Unknown loadMode action:  " + actionArg );
          }
       }
       
       try {
			SpringUtil.initDataSource();
	        ProgressMonitor.setConsoleModeAndParseShowProgress(args);
	        System.err.println("Reading data from:  " + dataFile.getAbsolutePath());
	        GeneticProfile geneticProfile = null;
	         try {
	            geneticProfile = GeneticProfileReader.loadGeneticProfile( descriptorFile );
	         } catch (java.io.FileNotFoundException e) {
	             quit( "Descriptor file '" + descriptorFile + "' not found." );
	         }
	
	        int numLines = FileUtil.getNumLines(dataFile);
	        System.err.println(" --> profile id:  " + geneticProfile.getGeneticProfileId());
	        System.err.println(" --> profile name:  " + geneticProfile.getProfileName());
	        System.err.println(" --> genetic alteration type:  " + geneticProfile.getGeneticAlterationType());
	        ProgressMonitor.setMaxValue(numLines);
	        
	        if (geneticProfile.getGeneticAlterationType().equals(GeneticAlterationType.MUTATION_EXTENDED)) {
	
	   
	            ImportExtendedMutationData importer = new ImportExtendedMutationData( dataFile,
	                  geneticProfile.getGeneticProfileId());
	            importer.importData();
	        }
		    else if (geneticProfile.getGeneticAlterationType().equals(GeneticAlterationType.FUSION)) {
		        ImportFusionData importer = new ImportFusionData(dataFile,
					geneticProfile.getGeneticProfileId());
		        importer.importData();
	        } else {
	            ImportTabDelimData importer = new ImportTabDelimData(dataFile, geneticProfile.getTargetLine(),
	                    geneticProfile.getGeneticProfileId());
	            importer.importData(numLines);
	        }
	        ConsoleUtil.showMessages();
	        System.err.println("Done.");
       }
       catch (IllegalArgumentException ia) {
    	   throw ia;
       }
       catch (Exception e) {
    	   ConsoleUtil.showWarnings();
    	   System.err.println("Error found: " + e.getMessage());
       }
       finally {
	        Date end = new Date();
	        long totalTime = end.getTime() - start.getTime();
	        System.out.println ("Total time:  " + totalTime + " ms\n");
       }
    }
}
