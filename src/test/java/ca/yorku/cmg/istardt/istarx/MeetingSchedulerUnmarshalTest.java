package ca.yorku.cmg.istardt.istarx;

import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.JAXBException;
import jakarta.xml.bind.Unmarshaller;
import jakarta.xml.bind.JAXBElement;
import java.io.File;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("MeetingScheduler XML Unmarshalling Test")
class MeetingSchedulerUnmarshalTest {

    @Test
    @DisplayName("Should unmarshal meetingScheduler.xml without errors")
    void testUnmarshalMeetingScheduler() {
        try {
            // Create JAXBContext and Unmarshaller
            JAXBContext context = JAXBContext.newInstance("ca.yorku.cmg.istardt.istarx");
            Unmarshaller unmarshaller = context.createUnmarshaller();
            
            // Path to the XML file
            File xmlFile = new File("docs/ver1.0/grammar/meetingScheduler.xml");
            
            // Unmarshal XML to Object
            Object result = unmarshaller.unmarshal(xmlFile);
            
            // Verify result is not null
            assertNotNull(result, "Unmarshalled object should not be null");
            System.out.println("Successfully unmarshalled to: " + result.getClass().getName());
            
            // Extract the model from JAXBElement if needed
            IstardtModelType model = null;
            if (result instanceof JAXBElement) {
                JAXBElement<?> element = (JAXBElement<?>) result;
                System.out.println("Root element name: " + element.getName());
                Object value = element.getValue();
                if (value instanceof IstardtModelType) {
                    model = (IstardtModelType) value;
                }
            } else if (result instanceof IstardtModelType) {
                model = (IstardtModelType) result;
            }
            
            assertNotNull(model, "Model should be extracted from unmarshalled object");
            
            // Access header
            ModelHeaderType header = model.getHeader();
            if (header != null) {
                System.out.println("\n=== Model Header ===");
                System.out.println("Title: " + header.getTitle());
                System.out.println("Author: " + header.getAuthor());
                System.out.println("Source: " + header.getSource());
                System.out.println("Last Updated: " + header.getLastUpdated());
                System.out.println("Description: " + header.getValue());
            }
            
            // Access options
            OptionsType options = model.getOptions();
            if (options != null) {
                System.out.println("\n=== Model Options ===");
                System.out.println("Continuous: " + options.isContinuous());
                System.out.println("Infeasible Action Penalty: " + options.getInfeasibleActionPenalty());
            }
            
            // Access actors
            Actors actors = model.getActors();
            if (actors != null) {
                System.out.println("\n=== Actors ===");
                System.out.println("Total actors: " + actors.getActor().size());
                for (ActorType actor : actors.getActor()) {
                    System.out.println("\nActor: " + actor.getName());
                    if (actor.getDescription() != null) {
                        System.out.println("  Description: " + actor.getDescription());
                    }
                    
                    // Access actor content
                    ActorContentType content = actor;
                    
                    // Access goals
                    Goals goals = actor.getGoals();
                    if (goals != null && !goals.getGoal().isEmpty()) {
                        System.out.println("  Goals: " + goals.getGoal().size());
                        for (GoalType goal : goals.getGoal()) {
                            System.out.println("    - " + goal.getName() + " (mode: " + goal.getMode() + ")");
                        }
                    }
                    
                    // Access tasks
                    Tasks tasks = actor.getTasks();
                    if (tasks != null && !tasks.getTask().isEmpty()) {
                        System.out.println("  Tasks: " + tasks.getTask().size());
                        for (TaskType task : tasks.getTask()) {
                            System.out.println("    - " + task.getName());
                        }
                    }
                }
            }
            
            // Access predicates
            Predicates predicates = model.getPredicates();
            if (predicates != null && !predicates.getPredicate().isEmpty()) {
                System.out.println("\n=== Predicates ===");
                System.out.println("Total predicates: " + predicates.getPredicate().size());
                for (PredicateType predicate : predicates.getPredicate()) {
                    System.out.println("  - " + predicate.getName() + 
                        (predicate.getDescription() != null ? " (" + predicate.getDescription() + ")" : ""));
                }
            }

            // Access initializations
            Initializations inits = model.getInitializations();
            if (inits != null) {
                System.out.println("\n=== Initializations ===");
                List<Object> initList = inits.getBoolInitOrNumInit();
                int boolCount = 0, numCount = 0;
                for (Object init : initList) {
                    if (init instanceof BoolInit) {
                        boolCount++;
                    } else if (init instanceof NumInit) {
                        numCount++;
                    }
                }
                System.out.println("Boolean initializations: " + boolCount);
                System.out.println("Numeric initializations: " + numCount);
            }
        } catch (JAXBException e) {
            fail("Failed to unmarshal XML: " + e.getMessage(), e);
        }
    }
}