package org.cbioportal.service.graphql;

import graphql.schema.DataFetcher;
import graphql.schema.DataFetchingEnvironment;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

import org.cbioportal.persistence.StudyRepository;
import org.cbioportal.model.CancerStudy;

import java.util.*;

@Component
public class CancerStudyFetcher {

    @Autowired
    private StudyRepository studyRepository;

    public DataFetcher getData() {
        return new DataFetcher() {
            @Override
            public Object get(DataFetchingEnvironment dfe) {
                List<Map<String, Object>> allCancerStudies = new ArrayList<>();
                if (dfe.containsArgument("cancerStudyIdentifier")) {
                    String cancerStudyIdentifier = dfe.getArgument("cancerStudyIdentifier");
                    CancerStudy study = studyRepository.getStudy(cancerStudyIdentifier, "SUMMARY");
                    allCancerStudies.add(getCancerStudyMapObject(study));
                }
                else {
                    // List<CancerStudy> allStudies = studyRepository.getAllStudies(Projection.SUMMARY, PagingConstants.MAX_PAGE_SIZE, PagingConstants.DEFAULT_PAGE_NUMBER, null, Direction.ASC);
                    List<CancerStudy> allStudies = studyRepository.getAllStudies("SUMMARY", 1000000, 0, null, "ASC");
                    for (CancerStudy study : allStudies) {
                        allCancerStudies.add(getCancerStudyMapObject(study));
                    }
                }
                return allCancerStudies;
            }
        };
    }

    private Map<String, Object> getCancerStudyMapObject(CancerStudy study) {
        Map<String, Object> cancerStudy = new HashMap<>();
        cancerStudy.put("name", study.getName());
        cancerStudy.put("shortName", study.getShortName());
        cancerStudy.put("description", study.getDescription());
        cancerStudy.put("cancerStudyIdentifier", study.getCancerStudyIdentifier());
        return cancerStudy;
    }
}