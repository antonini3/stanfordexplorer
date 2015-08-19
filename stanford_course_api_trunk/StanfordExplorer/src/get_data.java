/**
 * Created by lbronner on 8/16/15.
 */
import java.io.IOException;
import java.util.*;
import java.io.PrintWriter;


import org.json.JSONObject;

import edu.stanford.services.explorecourses.*;
import org.jdom2.JDOMException;

public class get_data {
    public static void main(String[] args) throws IOException, JDOMException {
        List <HashMap<String, Object> > classes = new ArrayList();
        ExploreCoursesConnection connection = new ExploreCoursesConnection();
        HashMap<Integer, Integer> sectionNumbers = new HashMap<>();
        for(School s : connection.getSchools()) {
            for (Department d : s.getDepartments()) {
                for (Course c : connection.getCoursesByQuery(d.getCode())) {
                    classes.add(mapFromCourse(c, sectionNumbers));
                }
            }
        }
        //drawHistogram(sectionNumbers);
        HashMap<String, List<HashMap<String, Object> > > results = new HashMap<>();
        results.put("results", classes);
        JSONObject jsonObject =  new JSONObject(results);
        String jsonString = jsonObject.toString();
        PrintWriter writer = new PrintWriter("all_class_data.json", "UTF-8");
        writer.println(jsonString);
        writer.close();
    }

    private static void drawHistogram(Map<Integer,Integer> data){
        SortedSet<Integer> keys = new TreeSet<Integer>(data.keySet());
        for(Integer key : keys){
            System.out.print(key + " : ");
            for(int i = 0; i< data.get(key); i++){
                System.out.print("*");
            }
            System.out.println();
        }
    }

    private static HashMap mapFromCourse(Course c,HashMap<Integer, Integer> sectionNumbers) {
        HashMap <String, Object>classMap = new HashMap<>();
        classMap.put("academic_year", c.getAcademicYear().toString());
        classMap.put("title", c.getTitle());
        classMap.put("description", c.getDescription());
        classMap.put("is_repeatable", c.isRepeatable());
        classMap.put("grading_basis", c.getGradingBasisOptions());
        classMap.put("minimum_units", c.getMinimumUnits());
        classMap.put("maximum_units", c.getMaximumUnits());
        classMap.put("GER", c.getGeneralEducationRequirementsSatisfied()); //this might be a problem
        classMap.put("subject_code_prefix", c.getSubjectCodePrefix());
        classMap.put("subject_code_suffix", c.getSubjectCodeSuffix());
        classMap.put("tags", tagSetToStringList(c.getTags()));
        classMap.put("section", sectionSetToList(c.getSections(), sectionNumbers));
        classMap.put("learning_objectives", learningObjectiveSetToList(c.getLearningObjectives()));
        classMap.put("attributes", attributesSetToList(c.getAttributes()));
        classMap.put("course_id", c.getCourseId());
        classMap.put("status", c.getStatus());
        classMap.put("offer_number", c.getOfferNumber());
        classMap.put("academic_group", c.getAcademicGroup());
        classMap.put("academic_organization", c.getAcademicOrganization());
        classMap.put("academic_career", c.getAcademicCareer());
        //classMap.put("has final exam", c.hasFinalExamFlag());
        classMap.put("has_catalog_print", c.hasCatalogPrintFlag());
        classMap.put("schedule_print", c.hasSchedulePrintFlag());
        classMap.put("max_units_repeat", c.getMaxUnitsRepeat());
        classMap.put("max_times_repeat", c.getMaxTimesRepeat());
        String fullTitle = c.getSubjectCodePrefix()+" "+c.getSubjectCodeSuffix()+" "+c.getTitle();
        classMap.put("full_title", fullTitle);
        return classMap;
    }

    private static List learningObjectiveSetToList(Set <LearningObjective> s) {
        List<HashMap> allLearningObjectives = new ArrayList<>();
        for(LearningObjective o : s) {
            HashMap<String, Object> learningObjective = new HashMap<>();
            learningObjective.put("requirement_code", o.getRequirementCode());
            learningObjective.put("description", o.getDescription());
            allLearningObjectives.add(learningObjective);
        }
        return allLearningObjectives;
    }

    private static List tagSetToStringList(Set <Tag> s) {
        List <HashMap> allTags = new ArrayList<>();
        for(Tag o : s) {
            HashMap<String, Object> tags = new HashMap<>();
            tags.put("organization", o.getOrganization());
            tags.put("name", o.getName());
            allTags.add(tags);
        }
        return allTags;
    }

    private static List sectionSetToList(Set <Section> s,  HashMap<Integer, Integer> sectionNumbers) {
        List <HashMap> allSections = new ArrayList<>();
        int counter = 0;
        for(Section o : s) {
            if(counter==100) { break; }
            counter += 1;
            HashMap<String, Object> sectionMap = new HashMap<>();
            sectionMap.put("id", o.getClassId());
            sectionMap.put("term", o.getTerm());
            sectionMap.put("term_id", o.getTermId());
            sectionMap.put("units", o.getUnits());
            sectionMap.put("section_number", o.getSectionNumber());
            sectionMap.put("component", o.getComponent());
            sectionMap.put("meeting_schedule", meetingScheduleSetToList(o.getMeetingSchedules()));
            sectionMap.put("attributes", attributesSetToList(o.getAttributes()));
            sectionMap.put("max_class_size", o.getMaxClassSize());
            sectionMap.put("current_class_size", o.getCurrentClassSize());
            sectionMap.put("current_waitlist_size", o.getCurrentWaitlistSize());
            sectionMap.put("max_waitlist_size", o.getMaxWaitlistSize());
            sectionMap.put("notes", o.getNotes());
            allSections.add(sectionMap);
        }
        if(sectionNumbers.containsKey(allSections.size())) {
            int currentNumber = sectionNumbers.get(allSections.size());
            sectionNumbers.put(allSections.size(), currentNumber + 1);
        } else {
            sectionNumbers.put(allSections.size(), 1);
        }
        return allSections;
    }

    private static List attributesSetToList(Set <Attribute> s) {
        List <HashMap> allAttributes = new ArrayList<>();
        for(Attribute o: s) {
            HashMap<String, Object> attribute = new HashMap<>();
            attribute.put("name", o.getName());
            attribute.put("value", o.getValue());
            attribute.put("description", o.getDescription());
            attribute.put("catalog_print", o.getCatalogPrint());
            attribute.put("get_schedule_print", o.getSchedulePrint());
            allAttributes.add(attribute);
        }
        return allAttributes;
    }

    private static List meetingScheduleSetToList(Set <MeetingSchedule> s) {
        List <HashMap> allMeetingSchedules = new ArrayList<>();
        for(MeetingSchedule o : s) {
            HashMap<String, Object> meetingScheduleMap = new HashMap<>();
            meetingScheduleMap.put("start_date", o.getStartDate());
            meetingScheduleMap.put("end_date", o.getEndDate());
            meetingScheduleMap.put("start_time", o.getStartTime());
            meetingScheduleMap.put("end_time", o.getEndTime());
            meetingScheduleMap.put("location", o.getLocation());
            meetingScheduleMap.put("days", o.getDays());
            meetingScheduleMap.put("instructors", instructorSetToList(o.getInstructors()));
            allMeetingSchedules.add(meetingScheduleMap);
        }
        return allMeetingSchedules;
    }

    private static List instructorSetToList(Set <Instructor> s) {
        List <HashMap> allInstructors = new ArrayList<>();
        for(Instructor o : s) {
            HashMap <String, Object> instructor = new HashMap<>();
            instructor.put("name", o.getName());
            instructor.put("first_name", o.getFirstName());
            instructor.put("last_name", o.getLastName());
            instructor.put("middle_name", o.getMiddleName());
            instructor.put("sunet_id", o.getSunet());
            instructor.put("is_primary_instructor", o.isPrimaryInstructor());
            allInstructors.add(instructor);
        }
        return allInstructors;
    }
}

