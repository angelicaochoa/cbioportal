-- A manually extracted subset of data for a small number of genes and samples from the BRCA
-- data set. This is intended to be used during unit testing, to validate the portal APIs.
-- In theory, it should be enough to run up a portal.
--
-- Prepared by Stuart Watt -- 13th May 2015

DROP TABLE IF EXISTS "mutation_count";
DROP TABLE IF EXISTS "mutation";
DROP TABLE IF EXISTS "mutation_event";
DROP TABLE IF EXISTS "genetic_profile_samples";
DROP TABLE IF EXISTS "sample_profile";
DROP TABLE IF EXISTS "sample_list_list";
DROP TABLE IF EXISTS "sample_list";
DROP TABLE IF EXISTS "sample";
DROP TABLE IF EXISTS "patient";
DROP TABLE IF EXISTS "genetic_profile";
DROP TABLE IF EXISTS "gene";
DROP TABLE IF EXISTS "cancer_study";
DROP TABLE IF EXISTS "type_of_cancer";

CREATE TABLE "type_of_cancer" (
  "TYPE_OF_CANCER_ID" VARCHAR(63) NOT NULL,
  "NAME" VARCHAR(255) NOT NULL,
  "CLINICAL_TRIAL_KEYWORDS" VARCHAR(1024) NOT NULL,
  "DEDICATED_COLOR" VARCHAR(31) NOT NULL,
  "SHORT_NAME" VARCHAR(127),
  "PARENT" VARCHAR(63),
  PRIMARY KEY  ("TYPE_OF_CANCER_ID")
);

CREATE TABLE "gene" (
  "ENTREZ_GENE_ID" INTEGER NOT NULL,
  "HUGO_GENE_SYMBOL" VARCHAR(255) NOT NULL,
  "TYPE" VARCHAR(50),
  "CYTOBAND" VARCHAR(50),
  "LENGTH" INTEGER,
  PRIMARY KEY ("ENTREZ_GENE_ID")
);

CREATE INDEX "HUGO_GENE_SYMBOL" ON "gene"("HUGO_GENE_SYMBOL");

CREATE TABLE "cancer_study" (
  "CANCER_STUDY_ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "CANCER_STUDY_IDENTIFIER" VARCHAR(255),
  "TYPE_OF_CANCER_ID" VARCHAR(25) NOT NULL,
  "NAME" VARCHAR(255) NOT NULL,
  "SHORT_NAME" VARCHAR(64) NOT NULL,
  "DESCRIPTION" VARCHAR(1024) NOT NULL,
  "PUBLIC" BOOLEAN NOT NULL,
  "PMID" VARCHAR(20) DEFAULT NULL,
  "CITATION" VARCHAR(200) DEFAULT NULL,
  "GROUPS" VARCHAR(200) DEFAULT NULL,
  "STATUS" INTEGER DEFAULT NULL,
  "IMPORT_DATE" DATETIME DEFAULT NULL,
  UNIQUE ("CANCER_STUDY_IDENTIFIER"),
  FOREIGN KEY ("TYPE_OF_CANCER_ID") REFERENCES "type_of_cancer" ("TYPE_OF_CANCER_ID")
);

CREATE TABLE "genetic_profile" (
  "GENETIC_PROFILE_ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "STABLE_ID" VARCHAR(255) NOT NULL,
  "CANCER_STUDY_ID" INTEGER NOT NULL,
  "GENETIC_ALTERATION_TYPE" VARCHAR(255) NOT NULL,
  "DATATYPE" VARCHAR(255) NOT NULL,
  "NAME" VARCHAR(255) NOT NULL,
  "DESCRIPTION" CLOB,
  "SHOW_PROFILE_IN_ANALYSIS_TAB" INTEGER NOT NULL,
  UNIQUE ("STABLE_ID"),
  FOREIGN KEY ("CANCER_STUDY_ID") REFERENCES "cancer_study" ("CANCER_STUDY_ID") ON DELETE CASCADE
);

CREATE TABLE "genetic_profile_samples" (
  "ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "GENETIC_PROFILE_ID" INTEGER NOT NULL,
  "ORDERED_SAMPLE_LIST" CLOB NOT NULL,
  UNIQUE ("GENETIC_PROFILE_ID"),
  FOREIGN KEY ("GENETIC_PROFILE_ID") REFERENCES "genetic_profile" ("GENETIC_PROFILE_ID") ON DELETE CASCADE
);

CREATE TABLE "patient" (
  "INTERNAL_ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "STABLE_ID" VARCHAR(50) NOT NULL,
  "CANCER_STUDY_ID" INTEGER NOT NULL,
  FOREIGN KEY ("CANCER_STUDY_ID") REFERENCES "cancer_study" ("CANCER_STUDY_ID") ON DELETE CASCADE
);

CREATE TABLE "sample" (
  "INTERNAL_ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "STABLE_ID" VARCHAR(50) NOT NULL,
  "SAMPLE_TYPE" VARCHAR(255) NOT NULL,
  "PATIENT_ID" INTEGER NOT NULL,
  "TYPE_OF_CANCER_ID" VARCHAR(25) NOT NULL,
  FOREIGN KEY ("PATIENT_ID") REFERENCES "patient" ("INTERNAL_ID") ON DELETE CASCADE,
  FOREIGN KEY ("TYPE_OF_CANCER_ID") REFERENCES "type_of_cancer" ("TYPE_OF_CANCER_ID")
);

CREATE TABLE "mutation_event" (
  "MUTATION_EVENT_ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "ENTREZ_GENE_ID" INTEGER NOT NULL,
  "CHR" VARCHAR(5),
  "START_POSITION" BIGINT,
  "END_POSITION" BIGINT,
  "REFERENCE_ALLELE" VARCHAR(255),
  "TUMOR_SEQ_ALLELE" VARCHAR(255),
  "PROTEIN_CHANGE" VARCHAR(255),
  "MUTATION_TYPE" VARCHAR(255),
  "FUNCTIONAL_IMPACT_SCORE" VARCHAR(50),
  "FIS_VALUE" FLOAT,
  "LINK_XVAR" VARCHAR(500),
  "LINK_PDB" VARCHAR(500),
  "LINK_MSA" VARCHAR(500),
  "NCBI_BUILD" VARCHAR(10),
  "STRAND" VARCHAR(2),
  "VARIANT_TYPE" VARCHAR(15),
  "DB_SNP_RS" VARCHAR(25),
  "DB_SNP_VAL_STATUS" VARCHAR(255),
  "ONCOTATOR_DBSNP_RS" VARCHAR(255),
  "ONCOTATOR_REFSEQ_MRNA_ID" VARCHAR(64),
  "ONCOTATOR_CODON_CHANGE" VARCHAR(255),
  "ONCOTATOR_UNIPROT_ENTRY_NAME" VARCHAR(64),
  "ONCOTATOR_UNIPROT_ACCESSION" VARCHAR(64),
  "ONCOTATOR_PROTEIN_POS_START" INTEGER,
  "ONCOTATOR_PROTEIN_POS_END" INTEGER,
  "CANONICAL_TRANSCRIPT" INTEGER,
  "KEYWORD" VARCHAR(50) DEFAULT NULL,
  UNIQUE ("CHR", "START_POSITION", "END_POSITION", "TUMOR_SEQ_ALLELE", "ENTREZ_GENE_ID", "PROTEIN_CHANGE", "MUTATION_TYPE"),
  FOREIGN KEY ("ENTREZ_GENE_ID") REFERENCES "gene" ("ENTREZ_GENE_ID")
);

CREATE INDEX "KEYWORD" ON "mutation_event"("KEYWORD");

CREATE TABLE "mutation" (
  "ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "MUTATION_EVENT_ID" INTEGER NOT NULL,
  "GENETIC_PROFILE_ID" INTEGER NOT NULL,
  "SAMPLE_ID" INTEGER NOT NULL,
  "ENTREZ_GENE_ID" INTEGER NOT NULL,
  "CENTER" VARCHAR(100),
  "SEQUENCER" VARCHAR(255),
  "MUTATION_STATUS" VARCHAR(25),
  "VALIDATION_STATUS" VARCHAR(25),
  "TUMOR_SEQ_ALLELE1" VARCHAR(255),
  "TUMOR_SEQ_ALLELE2" VARCHAR(255),
  "MATCHED_NORM_SAMPLE_BARCODE" VARCHAR(255),
  "MATCH_NORM_SEQ_ALLELE1" VARCHAR(255),
  "MATCH_NORM_SEQ_ALLELE2" VARCHAR(255),
  "TUMOR_VALIDATION_ALLELE1" VARCHAR(255),
  "TUMOR_VALIDATION_ALLELE2" VARCHAR(255),
  "MATCH_NORM_VALIDATION_ALLELE1" VARCHAR(255),
  "MATCH_NORM_VALIDATION_ALLELE2" VARCHAR(255),
  "VERIFICATION_STATUS" VARCHAR(10),
  "SEQUENCING_PHASE" VARCHAR(100),
  "SEQUENCE_SOURCE" VARCHAR(255) NOT NULL,
  "VALIDATION_METHOD" VARCHAR(255),
  "SCORE" VARCHAR(100),
  "BAM_FILE" VARCHAR(255),
  "TUMOR_ALT_COUNT" INTEGER,
  "TUMOR_REF_COUNT" INTEGER,
  "NORMAL_ALT_COUNT" INTEGER,
  "NORMAL_REF_COUNT" INTEGER,
  "AMINO_ACID_CHANGE" VARCHAR(255),
  FOREIGN KEY ("MUTATION_EVENT_ID") REFERENCES "mutation_event" ("MUTATION_EVENT_ID"),
  FOREIGN KEY ("ENTREZ_GENE_ID") REFERENCES "gene" ("ENTREZ_GENE_ID"),
  FOREIGN KEY ("GENETIC_PROFILE_ID") REFERENCES "genetic_profile" ("GENETIC_PROFILE_ID") ON DELETE CASCADE,
  FOREIGN KEY ("SAMPLE_ID") REFERENCES "sample" ("INTERNAL_ID") ON DELETE CASCADE
);

CREATE INDEX "GENETIC_PROFILE_ID_GENE" ON "mutation"("GENETIC_PROFILE_ID","ENTREZ_GENE_ID");
CREATE INDEX "GENETIC_PROFILE_ID_SAMPLE" ON "mutation"("GENETIC_PROFILE_ID","SAMPLE_ID");
CREATE INDEX "ENTREZ_GENE_ID" ON "mutation"("ENTREZ_GENE_ID");
CREATE INDEX "SAMPLE_ID" ON "mutation"("SAMPLE_ID");

CREATE TABLE "mutation_count" (
  "ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "GENETIC_PROFILE_ID" INTEGER NOT NULL,
  "SAMPLE_ID" INTEGER NOT NULL,
  "MUTATION_COUNT" INTEGER NOT NULL,
  FOREIGN KEY ("GENETIC_PROFILE_ID") REFERENCES "genetic_profile" ("GENETIC_PROFILE_ID") ON DELETE CASCADE,
  FOREIGN KEY ("SAMPLE_ID") REFERENCES "sample" ("INTERNAL_ID") ON DELETE CASCADE
);

CREATE INDEX "MUTATION_COUNT_GENETIC_PROFILE_ID" ON "mutation_count"("GENETIC_PROFILE_ID","SAMPLE_ID");

CREATE TABLE "sample_profile" (
  "ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "SAMPLE_ID" INTEGER NOT NULL,
  "GENETIC_PROFILE_ID" INTEGER NOT NULL,
  FOREIGN KEY ("GENETIC_PROFILE_ID") REFERENCES "genetic_profile" ("GENETIC_PROFILE_ID") ON DELETE CASCADE,
  FOREIGN KEY ("SAMPLE_ID") REFERENCES "sample" ("INTERNAL_ID") ON DELETE CASCADE
);

CREATE TABLE "sample_list" (
  "LIST_ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "STABLE_ID" VARCHAR(255) NOT NULL,
  "CATEGORY" VARCHAR(255) NOT NULL,
  "CANCER_STUDY_ID" INTEGER NOT NULL,
  "NAME" VARCHAR(255) NOT NULL,
  "DESCRIPTION" CLOB,
  UNIQUE ("STABLE_ID"),
  FOREIGN KEY ("CANCER_STUDY_ID") REFERENCES "cancer_study" ("CANCER_STUDY_ID") ON DELETE CASCADE
);

CREATE INDEX "STABLE_ID" ON "sample_list"("STABLE_ID");

CREATE TABLE "sample_list_list" (
  "ID" INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "LIST_ID" INTEGER NOT NULL,
  "SAMPLE_ID" INTEGER NOT NULL,
  FOREIGN KEY ("LIST_ID") REFERENCES "sample_list" ("LIST_ID") ON DELETE CASCADE,
  FOREIGN KEY ("SAMPLE_ID") REFERENCES "sample" ("INTERNAL_ID") ON DELETE CASCADE
);

CREATE INDEX "SAMPLE_LIST_LIST" ON "sample_list_list"("LIST_ID","SAMPLE_ID");

INSERT INTO "type_of_cancer" ("TYPE_OF_CANCER_ID","NAME","CLINICAL_TRIAL_KEYWORDS","DEDICATED_COLOR","SHORT_NAME","PARENT")
  VALUES ('brca','Breast Invasive Carcinoma','breast,breast invasive','HotPink','Breast','tissue');
INSERT INTO "cancer_study" ("CANCER_STUDY_ID", "CANCER_STUDY_IDENTIFIER", "TYPE_OF_CANCER_ID", "NAME", "SHORT_NAME", "DESCRIPTION", "PUBLIC", "PMID", "CITATION", "GROUPS")
  VALUES (1,'study_tcga_pub','brca','Breast Invasive Carcinoma (TCGA, Nature 2012)','BRCA (TCGA)','<a href=\"http://cancergenome.nih.gov/\">The Cancer Genome Atlas (TCGA)</a> Breast Invasive Carcinoma project. 825 cases.<br><i>Nature 2012.</i> <a href=\"http://tcga-data.nci.nih.gov/tcga/\">Raw data via the TCGA Data Portal</a>.',1,'23000897','TCGA, Nature 2012','SU2C-PI3K;PUBLIC;GDAC');

INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (207,'AKT1','protein-coding','14q32.32',10838);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (208,'AKT2','protein-coding','19q13.1-q13.2',15035);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (10000,'AKT3','protein-coding','1q44',7499);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (369,'ARAF','protein-coding','Xp11.4-p11.2',3204);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (472,'ATM','protein-coding','11q22-q23',22317);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (673,'BRAF','protein-coding','7q34',4564);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (672,'BRCA1','protein-coding','17q21',8426);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (675,'BRCA2','protein-coding','13q12.3',11269);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (3265,'HRAS','protein-coding','11p15.5',1854);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (3845,'KRAS','protein-coding','12p12.1',7302);
INSERT INTO "gene" ("ENTREZ_GENE_ID","HUGO_GENE_SYMBOL","TYPE","CYTOBAND","LENGTH") VALUES (4893,'NRAS','protein-coding','1p13.2',4449);

INSERT INTO "genetic_profile" ("GENETIC_PROFILE_ID", "STABLE_ID", "CANCER_STUDY_ID", "GENETIC_ALTERATION_TYPE", "DATATYPE", "NAME", "DESCRIPTION", "SHOW_PROFILE_IN_ANALYSIS_TAB") VALUES (2,'study_tcga_pub_gistic',1,'COPY_NUMBER_ALTERATION','DISCRETE','Putative copy-number alterations from GISTIC','Putative copy-number from GISTIC 2.0. Values: -2 = homozygous deletion; -1 = hemizygous deletion; 0 = neutral / no change; 1 = gain; 2 = high level amplification.',1);
INSERT INTO "genetic_profile" ("GENETIC_PROFILE_ID", "STABLE_ID", "CANCER_STUDY_ID", "GENETIC_ALTERATION_TYPE", "DATATYPE", "NAME", "DESCRIPTION", "SHOW_PROFILE_IN_ANALYSIS_TAB") VALUES (3,'study_tcga_pub_mrna',1,'MRNA_EXPRESSION','Z-SCORE','mRNA expression (microarray)','Expression levels (Agilent microarray).',0);
INSERT INTO "genetic_profile" ("GENETIC_PROFILE_ID", "STABLE_ID", "CANCER_STUDY_ID", "GENETIC_ALTERATION_TYPE", "DATATYPE", "NAME", "DESCRIPTION", "SHOW_PROFILE_IN_ANALYSIS_TAB") VALUES (4,'study_tcga_pub_log2CNA',1,'COPY_NUMBER_ALTERATION','LOG-VALUE','Log2 copy-number values','Log2 copy-number values for each gene (from Affymetrix SNP6).',0);
INSERT INTO "genetic_profile" ("GENETIC_PROFILE_ID", "STABLE_ID", "CANCER_STUDY_ID", "GENETIC_ALTERATION_TYPE", "DATATYPE", "NAME", "DESCRIPTION", "SHOW_PROFILE_IN_ANALYSIS_TAB") VALUES (5,'study_tcga_pub_methylation_hm27',1,'METHYLATION','CONTINUOUS','Methylation (HM27)','Methylation beta-values (HM27 platform). For genes with multiple methylation probes, the probe least correlated with expression is selected.',0);
INSERT INTO "genetic_profile" ("GENETIC_PROFILE_ID", "STABLE_ID", "CANCER_STUDY_ID", "GENETIC_ALTERATION_TYPE", "DATATYPE", "NAME", "DESCRIPTION", "SHOW_PROFILE_IN_ANALYSIS_TAB") VALUES (6,'study_tcga_pub_mutations',1,'MUTATION_EXTENDED','MAF','Mutations','Mutation data from whole exome sequencing.',1);

-- genetic_profile_samples
INSERT INTO "genetic_profile_samples" ("GENETIC_PROFILE_ID", "ORDERED_SAMPLE_LIST") VALUES (2,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,');
INSERT INTO "genetic_profile_samples" ("GENETIC_PROFILE_ID", "ORDERED_SAMPLE_LIST") VALUES (3,'2,3,6,8,9,10,12,13,');
INSERT INTO "genetic_profile_samples" ("GENETIC_PROFILE_ID", "ORDERED_SAMPLE_LIST") VALUES (4,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,');
INSERT INTO "genetic_profile_samples" ("GENETIC_PROFILE_ID", "ORDERED_SAMPLE_LIST") VALUES (5,'2,');

-- patient
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (1,'TCGA-A1-A0SB',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (2,'TCGA-A1-A0SD',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (3,'TCGA-A1-A0SE',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (4,'TCGA-A1-A0SF',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (5,'TCGA-A1-A0SG',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (6,'TCGA-A1-A0SH',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (7,'TCGA-A1-A0SI',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (8,'TCGA-A1-A0SJ',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (9,'TCGA-A1-A0SK',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (10,'TCGA-A1-A0SM',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (11,'TCGA-A1-A0SN',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (12,'TCGA-A1-A0SO',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (13,'TCGA-A1-A0SP',1);
INSERT INTO "patient" ("INTERNAL_ID", "STABLE_ID", "CANCER_STUDY_ID") VALUES (14,'TCGA-A1-A0SQ',1);

-- sample
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (1,'TCGA-A1-A0SB-01','Primary Solid Tumor',1,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (2,'TCGA-A1-A0SD-01','Primary Solid Tumor',2,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (3,'TCGA-A1-A0SE-01','Primary Solid Tumor',3,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (4,'TCGA-A1-A0SF-01','Primary Solid Tumor',4,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (5,'TCGA-A1-A0SG-01','Primary Solid Tumor',5,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (6,'TCGA-A1-A0SH-01','Primary Solid Tumor',6,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (7,'TCGA-A1-A0SI-01','Primary Solid Tumor',7,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (8,'TCGA-A1-A0SJ-01','Primary Solid Tumor',8,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (9,'TCGA-A1-A0SK-01','Primary Solid Tumor',9,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (10,'TCGA-A1-A0SM-01','Primary Solid Tumor',10,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (11,'TCGA-A1-A0SN-01','Primary Solid Tumor',11,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (12,'TCGA-A1-A0SO-01','Primary Solid Tumor',12,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (13,'TCGA-A1-A0SP-01','Primary Solid Tumor',13,'brca');
INSERT INTO "sample" ("INTERNAL_ID","STABLE_ID","SAMPLE_TYPE","PATIENT_ID","TYPE_OF_CANCER_ID") VALUES (14,'TCGA-A1-A0SQ-01','Primary Solid Tumor',14,'brca');

-- mutation_event
INSERT INTO "mutation_event" ("MUTATION_EVENT_ID","ENTREZ_GENE_ID","CHR","START_POSITION","END_POSITION","REFERENCE_ALLELE","TUMOR_SEQ_ALLELE","PROTEIN_CHANGE","MUTATION_TYPE","FUNCTIONAL_IMPACT_SCORE","FIS_VALUE","LINK_XVAR","LINK_PDB","LINK_MSA","NCBI_BUILD","STRAND","VARIANT_TYPE","DB_SNP_RS","DB_SNP_VAL_STATUS","ONCOTATOR_DBSNP_RS","ONCOTATOR_REFSEQ_MRNA_ID","ONCOTATOR_CODON_CHANGE","ONCOTATOR_UNIPROT_ENTRY_NAME","ONCOTATOR_UNIPROT_ACCESSION","ONCOTATOR_PROTEIN_POS_START","ONCOTATOR_PROTEIN_POS_END","CANONICAL_TRANSCRIPT","KEYWORD") VALUES (2038,672,'17',41244748,41244748,'G','A','Q934*','Nonsense_Mutation','NA',0,'getma.org/?cm=var&var=hg19,17,41244748,G,A&fts=all','NA','NA','37','+','SNP','rs80357223','unknown','rs80357223','NM_007294','c.(2800-2802)CAG>TAG','BRCA1_HUMAN','P38398',934,934,1,'BRCA1 truncating');
INSERT INTO "mutation_event" ("MUTATION_EVENT_ID","ENTREZ_GENE_ID","CHR","START_POSITION","END_POSITION","REFERENCE_ALLELE","TUMOR_SEQ_ALLELE","PROTEIN_CHANGE","MUTATION_TYPE","FUNCTIONAL_IMPACT_SCORE","FIS_VALUE","LINK_XVAR","LINK_PDB","LINK_MSA","NCBI_BUILD","STRAND","VARIANT_TYPE","DB_SNP_RS","DB_SNP_VAL_STATUS","ONCOTATOR_DBSNP_RS","ONCOTATOR_REFSEQ_MRNA_ID","ONCOTATOR_CODON_CHANGE","ONCOTATOR_UNIPROT_ENTRY_NAME","ONCOTATOR_UNIPROT_ACCESSION","ONCOTATOR_PROTEIN_POS_START","ONCOTATOR_PROTEIN_POS_END","CANONICAL_TRANSCRIPT","KEYWORD") VALUES (22604,672,'17',41258504,41258504,'A','C','C61G','Missense_Mutation','H',4.355,'getma.org/?cm=var&var=hg19,17,41258504,A,C&fts=all','getma.org/pdb.php?prot=BRCA1_HUMAN&from=24&to=64&var=C61G','getma.org/?cm=msa&ty=f&p=BRCA1_HUMAN&rb=24&re=64&var=C61G','37','+','SNP','rs28897672','byCluster','rs28897672','NM_007294','c.(181-183)TGT>GGT','BRCA1_HUMAN','P38398',61,61,1,'BRCA1 C61 missense');
INSERT INTO "mutation_event" ("MUTATION_EVENT_ID","ENTREZ_GENE_ID","CHR","START_POSITION","END_POSITION","REFERENCE_ALLELE","TUMOR_SEQ_ALLELE","PROTEIN_CHANGE","MUTATION_TYPE","FUNCTIONAL_IMPACT_SCORE","FIS_VALUE","LINK_XVAR","LINK_PDB","LINK_MSA","NCBI_BUILD","STRAND","VARIANT_TYPE","DB_SNP_RS","DB_SNP_VAL_STATUS","ONCOTATOR_DBSNP_RS","ONCOTATOR_REFSEQ_MRNA_ID","ONCOTATOR_CODON_CHANGE","ONCOTATOR_UNIPROT_ENTRY_NAME","ONCOTATOR_UNIPROT_ACCESSION","ONCOTATOR_PROTEIN_POS_START","ONCOTATOR_PROTEIN_POS_END","CANONICAL_TRANSCRIPT","KEYWORD") VALUES (2039,672,'17',41276033,41276033,'C','T','C27_splice','Splice_Site','NA',1.4013e-45,'NA','NA','NA','37','+','SNP','rs80358010','byCluster','rs80358010','NM_007294','c.e2+1','NA','NA',-1,-1,1,'BRCA1 truncating');

-- mutation
INSERT INTO "mutation" ("MUTATION_EVENT_ID","GENETIC_PROFILE_ID","SAMPLE_ID","ENTREZ_GENE_ID","CENTER","SEQUENCER","MUTATION_STATUS","VALIDATION_STATUS","TUMOR_SEQ_ALLELE1","TUMOR_SEQ_ALLELE2","MATCHED_NORM_SAMPLE_BARCODE","MATCH_NORM_SEQ_ALLELE1","MATCH_NORM_SEQ_ALLELE2","TUMOR_VALIDATION_ALLELE1","TUMOR_VALIDATION_ALLELE2","MATCH_NORM_VALIDATION_ALLELE1","MATCH_NORM_VALIDATION_ALLELE2","VERIFICATION_STATUS","SEQUENCING_PHASE","SEQUENCE_SOURCE","VALIDATION_METHOD","SCORE","BAM_FILE","TUMOR_ALT_COUNT","TUMOR_REF_COUNT","NORMAL_ALT_COUNT","NORMAL_REF_COUNT") VALUES (2038,6,6,672,'genome.wustl.edu','IlluminaGAIIx','Germline','Unknown','G','A','TCGA-A1-A0SH-10A-03D-A099-09','G','A','NA','NA','NA','NA','Unknown','Phase_IV','Capture','NA','1','dbGAP',-1,-1,-1,-1);
INSERT INTO "mutation" ("MUTATION_EVENT_ID","GENETIC_PROFILE_ID","SAMPLE_ID","ENTREZ_GENE_ID","CENTER","SEQUENCER","MUTATION_STATUS","VALIDATION_STATUS","TUMOR_SEQ_ALLELE1","TUMOR_SEQ_ALLELE2","MATCHED_NORM_SAMPLE_BARCODE","MATCH_NORM_SEQ_ALLELE1","MATCH_NORM_SEQ_ALLELE2","TUMOR_VALIDATION_ALLELE1","TUMOR_VALIDATION_ALLELE2","MATCH_NORM_VALIDATION_ALLELE1","MATCH_NORM_VALIDATION_ALLELE2","VERIFICATION_STATUS","SEQUENCING_PHASE","SEQUENCE_SOURCE","VALIDATION_METHOD","SCORE","BAM_FILE","TUMOR_ALT_COUNT","TUMOR_REF_COUNT","NORMAL_ALT_COUNT","NORMAL_REF_COUNT") VALUES (22604,6,6,672,'genome.wustl.edu','IlluminaGAIIx','Germline','Unknown','A','C','TCGA-A1-A0SH-10A-03D-A099-09','A','C','NA','NA','NA','NA','Unknown','Phase_IV','Capture','NA','1','dbGAP',-1,-1,-1,-1);
INSERT INTO "mutation" ("MUTATION_EVENT_ID","GENETIC_PROFILE_ID","SAMPLE_ID","ENTREZ_GENE_ID","CENTER","SEQUENCER","MUTATION_STATUS","VALIDATION_STATUS","TUMOR_SEQ_ALLELE1","TUMOR_SEQ_ALLELE2","MATCHED_NORM_SAMPLE_BARCODE","MATCH_NORM_SEQ_ALLELE1","MATCH_NORM_SEQ_ALLELE2","TUMOR_VALIDATION_ALLELE1","TUMOR_VALIDATION_ALLELE2","MATCH_NORM_VALIDATION_ALLELE1","MATCH_NORM_VALIDATION_ALLELE2","VERIFICATION_STATUS","SEQUENCING_PHASE","SEQUENCE_SOURCE","VALIDATION_METHOD","SCORE","BAM_FILE","TUMOR_ALT_COUNT","TUMOR_REF_COUNT","NORMAL_ALT_COUNT","NORMAL_REF_COUNT") VALUES (2039,6,12,672,'genome.wustl.edu','IlluminaGAIIx','Germline','Unknown','T','T','TCGA-A1-A0SO-10A-03D-A099-09','T','T','NA','NA','NA','NA','Unknown','Phase_IV','Capture','NA','1','dbGAP',-1,-1,-1,-1);

-- mutation_count
INSERT INTO "mutation_count" ("GENETIC_PROFILE_ID","SAMPLE_ID","MUTATION_COUNT") VALUES (6,2,32);
INSERT INTO "mutation_count" ("GENETIC_PROFILE_ID","SAMPLE_ID","MUTATION_COUNT") VALUES (6,3,14);
INSERT INTO "mutation_count" ("GENETIC_PROFILE_ID","SAMPLE_ID","MUTATION_COUNT") VALUES (6,6,78);
INSERT INTO "mutation_count" ("GENETIC_PROFILE_ID","SAMPLE_ID","MUTATION_COUNT") VALUES (6,8,29);
INSERT INTO "mutation_count" ("GENETIC_PROFILE_ID","SAMPLE_ID","MUTATION_COUNT") VALUES (6,9,50);
INSERT INTO "mutation_count" ("GENETIC_PROFILE_ID","SAMPLE_ID","MUTATION_COUNT") VALUES (6,10,24);
INSERT INTO "mutation_count" ("GENETIC_PROFILE_ID","SAMPLE_ID","MUTATION_COUNT") VALUES (6,12,165);

-- sample_profile
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (1,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (1,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (2,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (2,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (2,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (2,5);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (2,6);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (3,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (3,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (3,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (3,6);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (4,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (4,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (5,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (5,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (6,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (6,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (6,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (6,6);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (7,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (7,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (8,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (8,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (8,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (8,6);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (9,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (9,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (9,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (9,6);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (10,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (10,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (10,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (10,6);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (11,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (11,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (12,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (12,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (12,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (12,6);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (13,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (13,3);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (13,4);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (14,2);
INSERT INTO "sample_profile" ("SAMPLE_ID","GENETIC_PROFILE_ID") VALUES (14,4);

-- sample_list
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (1,'study_tcga_pub_all','other',1,'All Tumors','All tumor samples (14 samples)');
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (2,'study_tcga_pub_acgh','other',1,'Tumors aCGH','All tumors with aCGH data (778 samples)');
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (3,'study_tcga_pub_cnaseq','other',1,'Tumors with sequencing and aCGH data','All tumor samples that have CNA and sequencing data (482 samples)');
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (4,'study_tcga_pub_complete','other',1,'Complete samples (mutations, copy-number, expression)','Samples with complete data (463 samples)');
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (5,'study_tcga_pub_log2CNA','other',1,'Tumors log2 copy-number','All tumors with log2 copy-number data (778 samples)');
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (6,'study_tcga_pub_methylation_hm27','other',1,'Tumors with methylation data','All samples with methylation (HM27) data (311 samples)');
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (7,'study_tcga_pub_mrna','other',1,'Tumors with mRNA data (Agilent microarray)','All samples with mRNA expression data (526 samples)');
INSERT INTO "sample_list" ("LIST_ID", "STABLE_ID", "CATEGORY", "CANCER_STUDY_ID", "NAME", "DESCRIPTION") VALUES (8,'study_tcga_pub_sequenced','other',1,'Sequenced Tumors','All sequenced samples (507 samples)');

-- sample_list_list
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,1);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,3);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,4);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,5);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,6);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,7);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,8);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,9);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,10);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,11);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,12);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,13);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (1,14);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,1);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,3);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,4);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,5);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,6);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,7);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,8);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,9);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,10);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,11);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,12);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,13);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (2,14);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (3,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (3,3);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (3,6);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (3,8);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (3,9);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (3,10);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (3,12);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (4,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (4,3);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (4,6);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (4,8);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (4,9);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (4,10);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (4,12);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,1);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,3);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,4);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,5);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,6);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,7);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,8);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,9);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,10);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,11);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,12);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,13);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (5,14);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (6,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,3);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,6);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,8);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,9);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,10);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,12);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (7,13);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (8,2);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (8,3);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (8,6);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (8,8);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (8,9);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (8,10);
INSERT INTO "sample_list_list" ("LIST_ID","SAMPLE_ID") VALUES (8,12);

