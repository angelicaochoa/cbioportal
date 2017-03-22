package org.cbioportal.model;

import java.io.Serializable;
import java.util.List;

public class ClinicalEvent implements Serializable {
    
    private Integer clinicalEventId;
    private String studyId;
    private String patientId;
    private String eventType;
    private Integer startDate;
    private Integer stopDate;
    private List<ClinicalEventData> attributes;

    public Integer getClinicalEventId() {
        return clinicalEventId;
    }

    public void setClinicalEventId(Integer clinicalEventId) {
        this.clinicalEventId = clinicalEventId;
    }

    public String getStudyId() {
        return studyId;
    }

    public void setStudyId(String studyId) {
        this.studyId = studyId;
    }

    public String getPatientId() {
        return patientId;
    }

    public void setPatientId(String patientId) {
        this.patientId = patientId;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public Integer getStartDate() {
        return startDate;
    }

    public void setStartDate(Integer startDate) {
        this.startDate = startDate;
    }

    public Integer getStopDate() {
        return stopDate;
    }

    public void setStopDate(Integer stopDate) {
        this.stopDate = stopDate;
    }

    public List<ClinicalEventData> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<ClinicalEventData> attributes) {
        this.attributes = attributes;
    }
}
