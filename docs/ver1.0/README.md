# JAXB Code Generation & XML Unmarshalling Quick Start

## Overview
Generate Java classes from `iStarX.xsd` and unmarshal `meetingScheduler.xml` into a Java model.

## Commands

### Generate Java Classes from XSD
```bash
mvn clean generate-sources
```
Creates JAXB classes in `target/generated-sources/jaxb/`

### Compile Project
```bash
mvn compile
```
Compiles generated classes to `target/classes/`

### Run Unmarshalling Test
```bash
mvn test -Dtest=MeetingSchedulerUnmarshalTest
```
Executes the test that unmarshals `meetingScheduler.xml` to an `IstardtModelType` object

### Full Build & Test
```bash
mvn clean install
```

## Generated Files Location

Package: `ca.yorku.cmg.istardt.istarx`

Directory: `target/generated-sources/jaxb/ca/yorku/cmg/istardt/istarx/`

## How It Works

```text
// Create JAXB context & unmarshaller
JAXBContext context = JAXBContext.newInstance("ca.yorku.cmg.istardt.istarx");
Unmarshaller unmarshaller = context.createUnmarshaller();

// Unmarshal XML to object
Object result = unmarshaller.unmarshal(new File("docs/ver1.0/grammar/meetingScheduler.xml"));
IstardtModelType model = (IstardtModelType) ((JAXBElement<?>) result).getValue();

// Access object tree
model.getHeader().getTitle()                  
```

## Configuration

pom.xml JAXB Plugin:
```xml
 <plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>jaxb2-maven-plugin</artifactId>
    <version>3.1.0</version>
    <executions>
        <execution>
            <id>xjc-istarx</id>
            <phase>generate-sources</phase>
            <goals>
                <goal>xjc</goal>
            </goals>
            <configuration>
                <sources>
                    <source>docs/ver1.0/grammar/iStarX.xsd</source>
                </sources>
                <packageName>ca.yorku.cmg.istardt.istarx</packageName>
            </configuration>
        </execution>
    </executions>
</plugin>
```


## Mermaid diagram of the generated java model
```
classDiagram
direction BT
class ActivationType {
  + ActivationType() 
  # JAXBElement~?~ booleanExpression
  + setBooleanExpression(JAXBElement~?~) void
  + getBooleanExpression() JAXBElement~?~
}
class ActorContentType {
  + ActorContentType() 
  # Goals goals
  # Tasks tasks
  # Qualities qualities
  + setGoals(Goals) void
  + getTasks() Tasks
  + setTasks(Tasks) void
  + getQualities() Qualities
  + getGoals() Goals
  + setQualities(Qualities) void
}
class ActorType {
  + ActorType() 
  # String name
  # String description
  + getName() String
  + getDescription() String
  + setDescription(String) void
  + setName(String) void
}
class Actors {
  + Actors() 
  # List~ActorType~ actor
  + getActor() List~ActorType~
}
class AlwaysOp {
  + AlwaysOp() 
  # JAXBElement~?~ temporalFormula
  + getTemporalFormula() JAXBElement~?~
  + setTemporalFormula(JAXBElement~?~) void
}
class BinaryArithmeticOp {
  + BinaryArithmeticOp() 
  # Left left
  # Right right
  + getLeft() Left
  + getRight() Right
  + setLeft(Left) void
  + setRight(Right) void
}
class BoolInit {
  + BoolInit() 
  # PredicateType predicate
  # boolean value
  + setPredicate(PredicateType) void
  + isValue() boolean
  + setValue(boolean) void
  + getPredicate() PredicateType
}
class ComparisonType {
  + ComparisonType() 
  # ComparisonOp op
  # Left left
  # Right right
  + setOp(ComparisonOp) void
  + setLeft(Left) void
  + setRight(Right) void
  + getOp() ComparisonOp
  + getRight() Right
  + getLeft() Left
}
class CondContentType {
  + CondContentType() 
  # Params params
  # Condition condition
  + getCondition() Condition
  + setParams(Params) void
  + setCondition(Condition) void
  + getParams() Params
}
class Condition {
  + Condition() 
  # PredicateType predicate
  + getPredicate() PredicateType
  + setPredicate(PredicateType) void
}
class CrossRun {
  + CrossRun() 
  # QualityRefType qualityRef
  # PredicateType predicate
  # VariableType variable
  + getQualityRef() QualityRefType
  + setQualityRef(QualityRefType) void
  + getPredicate() PredicateType
  + getVariable() VariableType
  + setVariable(VariableType) void
  + setPredicate(PredicateType) void
}
class CrossRuns {
  + CrossRuns() 
  # List~CrossRun~ crossRun
  + getCrossRun() List~CrossRun~
}
class DefiniendumType {
  + DefiniendumType() 
  # ParametersType parameters
  # String name
  + setName(String) void
  + getName() String
  + setParameters(ParametersType) void
  + getParameters() ParametersType
}
class Definiens {
  + Definiens() 
  # JAXBElement~?~ booleanExpression
  + getBooleanExpression() JAXBElement~?~
  + setBooleanExpression(JAXBElement~?~) void
}
class Definition {
  + Definition() 
  # Definiens definiens
  # DefiniendumType definiendum
  + setDefiniendum(DefiniendumType) void
  + getDefiniendum() DefiniendumType
  + setDefiniens(Definiens) void
  + getDefiniens() Definiens
}
class Definitions {
  + Definitions() 
  # List~Definition~ definition
  + getDefinition() List~Definition~
}
class DefnRefType {
  + DefnRefType() 
  # ParametersType parameters
  # String name
  + getParameters() ParametersType
  + getName() String
  + setParameters(ParametersType) void
  + setName(String) void
}
class EffectContentType {
  + EffectContentType() 
  # List~TurnsTrue~ turnsTrue
  # PreType pre
  # List~TurnsFalse~ turnsFalse
  # List~Set~ set
  + getTurnsFalse() List~TurnsFalse~
  + setPre(PreType) void
  + getSet() List~Set~
  + getTurnsTrue() List~TurnsTrue~
  + getPre() PreType
}
class EffectGroupType {
  + EffectGroupType() 
  # List~EffectType~ effect
  + getEffect() List~EffectType~
}
class EffectType {
  + EffectType() 
  # BigDecimal probability
  # String name
  # String description
  # Boolean satisfying
  + setName(String) void
  + getDescription() String
  + setSatisfying(Boolean) void
  + setProbability(BigDecimal) void
  + isSatisfying() Boolean
  + setDescription(String) void
  + getProbability() BigDecimal
  + getName() String
}
class EventuallyOp {
  + EventuallyOp() 
  # JAXBElement~?~ temporalFormula
  + setTemporalFormula(JAXBElement~?~) void
  + getTemporalFormula() JAXBElement~?~
}
class Export {
  + Export() 
  # VariableType variable
  # boolean continuous
  # BigDecimal minVal
  # TaskRefType taskRef
  # QualityRefType qualityRef
  # PredicateType predicate
  # BigDecimal maxVal
  # GoalRefType goalRef
  + setGoalRef(GoalRefType) void
  + getPredicate() PredicateType
  + setMinVal(BigDecimal) void
  + getGoalRef() GoalRefType
  + getTaskRef() TaskRefType
  + getMinVal() BigDecimal
  + setContinuous(boolean) void
  + isContinuous() boolean
  + setQualityRef(QualityRefType) void
  + getMaxVal() BigDecimal
  + getVariable() VariableType
  + setPredicate(PredicateType) void
  + getQualityRef() QualityRefType
  + setTaskRef(TaskRefType) void
  + setMaxVal(BigDecimal) void
  + setVariable(VariableType) void
}
class ExportedSet {
  + ExportedSet() 
  # List~Export~ export
  + getExport() List~Export~
}
class FulfillmentType {
  + FulfillmentType() 
  # JAXBElement~?~ booleanExpression
  + setBooleanExpression(JAXBElement~?~) void
  + getBooleanExpression() JAXBElement~?~
}
class GoalDefnType {
  + GoalDefnType() 
  # ActivationType activation
  # FulfillmentType fulfillment
  + setActivation(ActivationType) void
  + getActivation() ActivationType
  + setFulfillment(FulfillmentType) void
  + getFulfillment() FulfillmentType
}
class GoalRefType {
  + GoalRefType() 
  # ParametersType parameters
  # String name
  + setName(String) void
  + setParameters(ParametersType) void
  + getName() String
  + getParameters() ParametersType
}
class GoalType {
  + GoalType() 
  # GoalDefnType goalDefn
  # RefinementType refinement
  # String actor
  # GoalMode mode
  # TriType tri
  # BigInteger episodeLength
  # String name
  # PreType pre
  # String description
  # Boolean terminal
  # ParametersType parameters
  # ActStyle activationStyle
  # Boolean root
  + getGoalDefn() GoalDefnType
  + setRoot(Boolean) void
  + getPre() PreType
  + getActivationStyle() ActStyle
  + setTerminal(Boolean) void
  + setName(String) void
  + setTri(TriType) void
  + getRefinement() RefinementType
  + getName() String
  + isTerminal() Boolean
  + setParameters(ParametersType) void
  + isRoot() Boolean
  + setMode(GoalMode) void
  + getEpisodeLength() BigInteger
  + setActor(String) void
  + setPre(PreType) void
  + setDescription(String) void
  + getTri() TriType
  + getMode() GoalMode
  + setActivationStyle(ActStyle) void
  + setGoalDefn(GoalDefnType) void
  + setEpisodeLength(BigInteger) void
  + getActor() String
  + setRefinement(RefinementType) void
  + getDescription() String
  + getParameters() ParametersType
}
class Goals {
  + Goals() 
  # List~GoalType~ goal
  + getGoal() List~GoalType~
}
class ImpliesOp {
  + ImpliesOp() 
  # List~JAXBElement~?~~ content
  + getContent() List~JAXBElement~?~~
}
class Initializations {
  + Initializations() 
  # List~Object~ boolInitOrNumInit
  + getBoolInitOrNumInit() List~Object~
}
class Invariant {
  + Invariant() 
  # JAXBElement~?~ temporalFormula
  + setTemporalFormula(JAXBElement~?~) void
  + getTemporalFormula() JAXBElement~?~
}
class Invariants {
  + Invariants() 
  # List~Invariant~ invariant
  + getInvariant() List~Invariant~
}
class IstardtModelType {
  + IstardtModelType() 
  # CrossRuns crossRuns
  # ModelHeaderType header
  # Actors actors
  # Initializations initializations
  # Definitions definitions
  # Predicates predicates
  # Invariants invariants
  # Variables variables
  # ExportedSet exportedSet
  # OptionsType options
  + getInitializations() Initializations
  + setVariables(Variables) void
  + getInvariants() Invariants
  + getHeader() ModelHeaderType
  + getCrossRuns() CrossRuns
  + getOptions() OptionsType
  + setExportedSet(ExportedSet) void
  + setPredicates(Predicates) void
  + setInitializations(Initializations) void
  + getVariables() Variables
  + getActors() Actors
  + getPredicates() Predicates
  + setInvariants(Invariants) void
  + getDefinitions() Definitions
  + setDefinitions(Definitions) void
  + setOptions(OptionsType) void
  + setActors(Actors) void
  + setCrossRuns(CrossRuns) void
  + setHeader(ModelHeaderType) void
  + getExportedSet() ExportedSet
}
class Left {
  + Left() 
  # JAXBElement~?~ temporalFormula
  + setTemporalFormula(JAXBElement~?~) void
  + getTemporalFormula() JAXBElement~?~
}
class Left {
  + Left() 
  # JAXBElement~?~ numericExpression
  # JAXBElement~?~ atomBool
  + setAtomBool(JAXBElement~?~) void
  + setNumericExpression(JAXBElement~?~) void
  + getNumericExpression() JAXBElement~?~
  + getAtomBool() JAXBElement~?~
}
class Left {
  + Left() 
  # JAXBElement~?~ atomBool
  # JAXBElement~?~ numericExpression
  + setAtomBool(JAXBElement~?~) void
  + setNumericExpression(JAXBElement~?~) void
  + getAtomBool() JAXBElement~?~
  + getNumericExpression() JAXBElement~?~
}
class ModelHeaderType {
  + ModelHeaderType() 
  # String source
  # String title
  # String lastUpdated
  # String author
  # String value
  + getAuthor() String
  + setTitle(String) void
  + getSource() String
  + setAuthor(String) void
  + setValue(String) void
  + getLastUpdated() String
  + getTitle() String
  + setLastUpdated(String) void
  + setSource(String) void
  + getValue() String
}
class NaryArithmeticOp {
  + NaryArithmeticOp() 
  # List~JAXBElement~?~~ numericExpressionOrAtomBool
  + getNumericExpressionOrAtomBool() List~JAXBElement~?~~
}
class NaryBooleanOp {
  + NaryBooleanOp() 
  # List~JAXBElement~?~~ booleanExpression
  + getBooleanExpression() List~JAXBElement~?~~
}
class NextOp {
  + NextOp() 
  # JAXBElement~?~ temporalFormula
  + getTemporalFormula() JAXBElement~?~
  + setTemporalFormula(JAXBElement~?~) void
}
class NotOp {
  + NotOp() 
  # JAXBElement~?~ booleanExpression
  + setBooleanExpression(JAXBElement~?~) void
  + getBooleanExpression() JAXBElement~?~
}
class NumInit {
  + NumInit() 
  # QualityRefType qualityRef
  # BigDecimal value
  # VariableType variable
  + getQualityRef() QualityRefType
  + getVariable() VariableType
  + setQualityRef(QualityRefType) void
  + getValue() BigDecimal
  + setValue(BigDecimal) void
  + setVariable(VariableType) void
}
class OptionsType {
  + OptionsType() 
  # boolean continuous
  # BigDecimal infeasibleActionPenalty
  + getInfeasibleActionPenalty() BigDecimal
  + setInfeasibleActionPenalty(BigDecimal) void
  + isContinuous() boolean
  + setContinuous(boolean) void
}
class ParameterType {
  + ParameterType() 
  # String paramType
  # String paramName
  + getParamName() String
  + getParamType() String
  + setParamName(String) void
  + setParamType(String) void
}
class ParametersType {
  + ParametersType() 
  # List~ParameterType~ parameter
  + getParameter() List~ParameterType~
}
class Params {
  + Params() 
  # List~String~ param
  + getParam() List~String~
}
class PreType {
  + PreType() 
  # JAXBElement~?~ booleanExpression
  + setBooleanExpression(JAXBElement~?~) void
  + getBooleanExpression() JAXBElement~?~
}
class PredicateType {
  + PredicateType() 
  # ParametersType parameters
  # String description
  # String name
  + getDescription() String
  + getName() String
  + setDescription(String) void
  + getParameters() ParametersType
  + setParameters(ParametersType) void
  + setName(String) void
}
class Predicates {
  + Predicates() 
  # List~PredicateType~ predicate
  + getPredicate() List~PredicateType~
}
class PreviousBoolOp {
  + PreviousBoolOp() 
  # JAXBElement~?~ atomBool
  + setAtomBool(JAXBElement~?~) void
  + getAtomBool() JAXBElement~?~
}
class PreviousOp {
  + PreviousOp() 
  # QualityRefType qualityRef
  # JAXBElement~?~ atomBool
  # VariableType variable
  + getAtomBool() JAXBElement~?~
  + getVariable() VariableType
  + getQualityRef() QualityRefType
  + setAtomBool(JAXBElement~?~) void
  + setQualityRef(QualityRefType) void
  + setVariable(VariableType) void
}
class Qualities {
  + Qualities() 
  # List~QualityType~ quality
  + getQuality() List~QualityType~
}
class QualityRefType {
  + QualityRefType() 
  # String name
  + setName(String) void
  + getName() String
}
class QualityType {
  + QualityType() 
  # JAXBElement~?~ numericExpression
  # Boolean root
  # String name
  # String description
  + getNumericExpression() JAXBElement~?~
  + setNumericExpression(JAXBElement~?~) void
  + getName() String
  + setName(String) void
  + isRoot() Boolean
  + getDescription() String
  + setRoot(Boolean) void
  + setDescription(String) void
}
class RefCondition {
  + RefCondition() 
  # CondContentType forall
  # CondContentType pick
  + setForall(CondContentType) void
  + getPick() CondContentType
  + getForall() CondContentType
  + setPick(CondContentType) void
}
class RefType {
<<enumeration>>
  - RefType() 
  +  OR
  +  AND
  + values() RefType[]
  + fromValue(String) RefType
  + value() String
  + valueOf(String) RefType
}
class RefinementType {
  + RefinementType() 
  # RefCondition refCondition
  # List~Object~ goalRefOrTaskRef
  # RefType type
  + getType() RefType
  + getRefCondition() RefCondition
  + setRefCondition(RefCondition) void
  + getGoalRefOrTaskRef() List~Object~
  + setType(RefType) void
}
class Right {
  + Right() 
  # JAXBElement~?~ numericExpression
  # JAXBElement~?~ atomBool
  + setNumericExpression(JAXBElement~?~) void
  + getNumericExpression() JAXBElement~?~
  + getAtomBool() JAXBElement~?~
  + setAtomBool(JAXBElement~?~) void
}
class Right {
  + Right() 
  # JAXBElement~?~ temporalFormula
  + setTemporalFormula(JAXBElement~?~) void
  + getTemporalFormula() JAXBElement~?~
}
class Right {
  + Right() 
  # JAXBElement~?~ numericExpression
  # JAXBElement~?~ atomBool
  + getAtomBool() JAXBElement~?~
  + setNumericExpression(JAXBElement~?~) void
  + getNumericExpression() JAXBElement~?~
  + setAtomBool(JAXBElement~?~) void
}
class Set {
  + Set() 
  # VariableType variable
  # BigDecimal numConst
  + setVariable(VariableType) void
  + setNumConst(BigDecimal) void
  + getNumConst() BigDecimal
  + getVariable() VariableType
}
class TaskRefType {
  + TaskRefType() 
  # ParametersType parameters
  # String name
  + getParameters() ParametersType
  + setParameters(ParametersType) void
  + getName() String
  + setName(String) void
}
class TaskType {
  + TaskType() 
  # TriType tri
  # ActStyle activationStyle
  # ParametersType parameters
  # EffectGroupType effectGroup
  # String actor
  # String description
  # String name
  # PreType pre
  + setPre(PreType) void
  + getPre() PreType
  + setTri(TriType) void
  + getName() String
  + getEffectGroup() EffectGroupType
  + getParameters() ParametersType
  + getTri() TriType
  + getActivationStyle() ActStyle
  + setName(String) void
  + setActivationStyle(ActStyle) void
  + setEffectGroup(EffectGroupType) void
  + setDescription(String) void
  + setParameters(ParametersType) void
  + getActor() String
  + getDescription() String
  + setActor(String) void
}
class Tasks {
  + Tasks() 
  # List~TaskType~ task
  + getTask() List~TaskType~
}
class TriType {
  + TriType() 
  # JAXBElement~?~ booleanExpression
  + setBooleanExpression(JAXBElement~?~) void
  + getBooleanExpression() JAXBElement~?~
}
class TurnsFalse {
  + TurnsFalse() 
  # PredicateType predicate
  + getPredicate() PredicateType
  + setPredicate(PredicateType) void
}
class TurnsTrue {
  + TurnsTrue() 
  # PredicateType predicate
  + setPredicate(PredicateType) void
  + getPredicate() PredicateType
}
class UntilOp {
  + UntilOp() 
  # Right right
  # Left left
  + setRight(Right) void
  + setLeft(Left) void
  + getRight() Right
  + getLeft() Left
}
class VariableType {
  + VariableType() 
  # String name
  # String description
  + getName() String
  + getDescription() String
  + setDescription(String) void
  + setName(String) void
}
class Variables {
  + Variables() 
  # List~VariableType~ variable
  + getVariable() List~VariableType~
}
class node49 {
<<Interface>>

}

ActorType  -->  ActorContentType 
CondContentType  -->  Condition 
EffectType  -->  EffectContentType 
BinaryArithmeticOp  -->  Left 
ComparisonType  -->  Left 
UntilOp  -->  Left 
CondContentType  -->  Params 
BinaryArithmeticOp  -->  Right 
ComparisonType  -->  Right 
UntilOp  -->  Right 
```