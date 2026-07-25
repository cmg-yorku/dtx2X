#### Primitives, Enums
##### BNF
```
### [symbol]		::= Any valid XML character except quotes and angle brackets
[letter] 		::= "A" | "B" | ... | "Z" | "a" | "b" | ... | "z"
[letter-small]	::= "a" | "b" | ... | "z"
[digit] 		::= "0" | "1" | ... | "9"
## [character] 	::= [letter] | [digit] | [symbol]
[alphanum] 		::= [letter] | [digit] | " "
## [string] 		::= [character]+
[identifier] 	::= [letter-small][alphanum]*
## [boolean] 		::= "true" | "false"
## [decimal] 		::= [digit]+ [ "." [digit]+ ]
## [integer] 		::= [digit]+
```
##### XSD
```xml
<xs:simpleType name="identifier">
  <xs:restriction base="xs:token">
    <xs:pattern value="[a-z][A-Za-z0-9 ]*"/>
  </xs:restriction>
</xs:simpleType>

<xs:simpleType name="comparisonOp">
  <xs:restriction base="xs:string">
    <xs:enumeration value="gt"/>
    <xs:enumeration value="gte"/>
    <xs:enumeration value="lt"/>
    <xs:enumeration value="lte"/>
    <xs:enumeration value="eq"/>
    <xs:enumeration value="neq"/>
  </xs:restriction>
</xs:simpleType>
```

#### Boolean Expressions
##### BNF
```
[boolean-expression] 	::= [bool-const] | [atom] | [numeric-comparison] | [boolean-operation]
[bool-const] 			::= "<boolConst>" [boolean] "</boolConst>"
[atom] 					::= [predicate-ref] | [goal-ref] | [task-ref]
[boolean-operation] 	::= [and] | [or] | [not] | [prev]
[and] 					::= "<and>" [boolean-expression] [boolean-expression]+ "</and>"
[or] 					::= "<or>" [boolean-expression] [boolean-expression]+ "</or>"
[not] 					::= "<not>" [boolean-expression] "</not>"
[implies] 				::= "<implies>" [boolean-expression] [boolean-expression] "</implies>"
[prev] 					::= "<previous>" [atom] "</previous>"
[comparison-op] 		::= "gt" | "gte" | "lt" | "lte" | "eq" | "neq"
[numeric-comparison] 	::= "<" [comparison-op] ">"
							"<left>" [numeric-expression] "</left>"
							"<right>" [numeric-expression] "</right>"
							"</" [comparison-op] ">"
```

##### XSD
```xml
<!-- Abstract head: every concrete expression node substitutes for this -->
<xs:element name="booleanExpression" type="xs:anyType" abstract="true"/>
	
	<!-- [bool-Const] Def -->
	<xs:element name="boolConst" substitutionGroup="booleanExpression" type="xs:boolean"/>
	
	<!-- [atom] Def -->
	<xs:element name="atom" abstract="true" substitutionGroup="booleanExpression"/>
		<xs:element name="predicateRef" substitutionGroup="atom" type="idn:identifier"/>
		<xs:element name="goalRef"      substitutionGroup="atom" type="idn:identifier"/>
		<xs:element name="taskRef"      substitutionGroup="atom" type="idn:identifier"/>

	<!-- [boolean-operation] Def / n-ary case -->
	<xs:complexType name="naryBooleanOp">
	  <xs:sequence>
	    <xs:element ref="booleanExpression" minOccurs="2" maxOccurs="unbounded"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="and" substitutionGroup="booleanExpression" type="naryBooleanOp"/>
	<xs:element name="or"  substitutionGroup="booleanExpression" type="naryBooleanOp"/>

	<!-- [boolean-operation] Def / unary case (not) -->
	<xs:complexType name="notOp">
	  <xs:sequence>
	    <xs:element ref="booleanExpression"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="not" substitutionGroup="booleanExpression" type="notOp"/>

	<!-- [boolean-operation] Def / binary case (implies) -->
	<xs:complexType name="impliesOp">
	  <xs:sequence>
	    <xs:element ref="booleanExpression"/>
	    <xs:element ref="booleanExpression"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="implies" substitutionGroup="booleanExpression" type="impliesOp"/>

	<!-- [boolean-operation] Def / unary case (previous) -->
	<xs:complexType name="previousOp">
	  <xs:sequence>
	    <xs:element ref="atom"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="previous" substitutionGroup="booleanExpression" type="previousOp"/>
```

#### Numeric Expressions
```
[numeric-expression] 	::= [num-const] | [num-atom] | [num-previous] |
							[arithmetic-operation]
[num-const] 			::= "<numConst>" [decimal] "</numConst>"
[num-atom] 				::= [atom] | [variable-id] | [qual-id]
[variable-id] 			::= "<variableID>" [identifier] "</variableID>"
[qual-id] 				::= "<qualID>" [identifier] "</qualID>"
[num-previous] 			::= "<previous>" [num-atom] "</previous>"
[arithmetic-operator] 	::= [add] | [subtract] | [multiply] | [divide]
[add] 					::= "<add>" [numeric-expression] [numeric-expression]+ "</add>"
[multiply] 				::= "<multiply>" [numeric-expression] [numeric-expression]+
							"</multiply>"
[subtract] 				::= "<subtract>" "<left>" [numeric-expression] "</left>"
							"<right>" [numeric-expression] "</right>" "</subtract>"
[divide] 				::= "<divide>" "<left>" [numeric-expression] "</left>"
							"<right>" [numeric-expression] "</right>" "</divide>"
```
#### Parameters
```
[parameters] 	::= "<parameters>" [parameter]+ "</parameters>"
[parameter] 	::= "<parameter>" [param-type] [param-name] "</parameter>"
[param-type] 	::= "<param-type>" [identifier] "</param-type>"
[param-name] 	::= "<param-name>" [identifier] "</param-name>"
```
#### Temporal Formulae
```
[temporal-formula] ::= [boolean-expression]
[temporal-formula] ::= "<always>" [temp-form] "</always>"
[temporal-formula] ::= "<eventually>" [temp-form] "</eventually>"
[temporal-formula] ::= "<next>" [temp-form] "</next>"
[temporal-formula] ::= "<until>" [temp-form] [temp-form] "</until>"
```

#### Root
```
[istardt-model] 	::= "<iStarDT " [namespaces] ">" [model-header] [options] [actors]
						"</iStarDT>"
[namespaces] 		::= " xmlns=‘" [string] "’" [" xmlns:xsi=‘" [string] "’]
						[" xsi:schemaLocation= ‘" [string] "’"]
[model-header]		::= "<header title = ‘" [string] "’ author = ‘" [string]
						"’ source = ‘" [string] "’ lastUpdated=‘" [string] "’>"
						[string] "</header>"
[options] 			::= "<options continuous = ‘" [boolean] "’
						infeasibleActionPenalty = ‘" [decimal] "’>
						</options>"
[actors] 			::= "<actors>" [actor]+ "</actors>"
[actor] 			::= "<actor " [actor-attributes] ">" [actor-content] "</actor>"
[actor-attributes]	::= "name=‘" [identifier] "’" [description=‘" [string] "’]
[actor-content] 	::= [ [goals] ] [ [tasks] ] [ [qualities] ] [ [predicates] ] 						
						[ [variables] ] [ [condBoxes] ] [ [cross-runs] ]
						[ [exported-set] ][ [initializations] ] [ [definitions] ]
						[ [invars] ]
```


#### Goals
```
[goals] 		::= "<goals>" [goal]+ "</goals>"
[goal] 			::= "<goal name=‘" [identifier] "’ mode = " [goal-mode]
					[" root = ‘" [boolean] "’"] [" activation = " [act-style] "]
					[" description=‘" [string] "’"] [" terminal=‘" [boolean] "’"]
					[" episodeLength=‘" [integer] "’"] [" actor=‘" [identifier] "’"]
					[goal-content] "</goal>"
[goal-mode] 	::= ‘achieve’ | ‘maintain" | ‘avoid’
[act-style] 	::= ‘called’ | ‘triggered’
[goal-content]	::= [ [parameters] ] [ [pre] ] [ [tri] ] [ [goal-defn] ] [ [refinement] ]
[pre]			::= "<pre>" [boolean-expression] "</pre>"
[tri]			::= "<tri>" [boolean-expression] "</tri>"
[goal-defn]		::= "<goal-defn>" [activation] [fulfillment] "</goal-defn>"
[activation]	::= "<activation>" [boolean-expression] "</activation>"
[fulfillment]	::= "<fulfillment>" [boolean-expression] "</fulfillment>"
[refinement]	::= "<refinement type=‘" [ref-type] "’>"
					[ [ref-condition] ]
					([childGoal] | [childTask])+ "</refinement>"
[ref-type]		::= "AND" | "OR"
[ref-condition]	::= "<ref-condition>" [pick-cond] | [forall-cond] "</ref-condition>"
[pick-cond]		::= "<pick>" [cond-content] "</pick>"
[forall-cond]	::= "<forall>" [cond-content] "</forall>"
[cond-content]	::= "<params>" [cond-param]+ "</params>"
					"<condition>" [predicate-ref] "</condition>"
[cond-param]	::= "<param>" [identifier] "</param>"
[childGoal]		::= [goal-ref]
[childTask]		::= [task-ref]
[goal-ref]		::= "<goal name=‘" [identifier] "’>" [parameters] "</goal>"
```
#### Tasks
```
[tasks]			::= "<tasks>" [task]+ "</tasks>"
[task]			::= "<task name=‘" [identifier] "’" [" description=‘" [string] "’"]
			[" actor=‘" [identifier] "’"] [" delegation-style=" [del-style] "]
			">" [task-content] "</task>"
[task-content]	::= [ [parameters] ] [effectGroup] [ [pre] ] [ [tri] ]
[effectGroup]	::= "<effectGroup>" [effect]+ "</effectGroup>"
[effect]		::= "<effect name=‘" [identifier] "’" [ " satisfying=‘" [boolean] "’" ]
					" probability=‘" [decimal] "’" [ " description=‘" <string> "’" ]
					">" [effect-content] "</effect>"
[effect-content]::= [ [turnsTrue]* ] [ [turnsFalse]* ] [ [sets]* ] [ [pre] ] [ [npr] ]
[turnsTrue]		::= "<turnsTrue>" [predicate-ref] "</turnsTrue>"
[turnsFalse]	::= "<turnsFalse>" [predicate-ref] "</turnsFalse>"
[sets]			::= "<set>" [variable-id] [num-const] "</set>"
[task-ref]		::= "<task name=‘" [identifier] "’>" [parameters] "</task>"
```
#### Qualities
```
[qualities]	::= "<qualities>" [quality]+ "</qualities>"
[quality]	::= "<quality name=‘" [identifier] "’" [" description=‘" [string] "’"]
				[" root=‘" [boolean] "’"] ">"
				[numeric-expression] "</quality>"
```
#### Predicates and Variables
```
[predicates]	::= "<predicates>" [predicate]+ "</predicates>"
[predicate]		::= "<predicate name = ‘" [identifier] "’ description =‘" [string] "’>"
					[ [parameters] ] "</predicate>" % see above
[predicate-ref]	::= "<predicate name = ‘" [identifier] "’>"
					[ [parameters] ] "</predicate>" % see above
[variables] 	::= "<variables>" [variable]+ "</variables>"
[variable] 		::= "<variable description =‘" [string] "’>"
					[identifier] "</variable>"
```
#### Condition Boxes
```
[condBoxes]	::= "<condBoxes>" [condBox]+ "</condBoxes>"
[condBox]	::= "<condBox name=‘" [identifier] "’" [" description=‘" <string> "’"] ">"
				[predicate-ref]"</condBox>"
```
#### Cross-runs, Exported Sets, Initializations, Definitinos
```
[cross-runs]	::= "<crossRuns>" [cross-run]+ "</crossRuns>"
[cross-run]		::= "<crossRun>" [predicate-id] | [variable-id] | [qual-id]
"</crossRun>"
[exported-set]	::= "<exportedSet>" [export]+ "</exportedSet>"
[export]		::= "<export continuous=" [boolean] [ "minVal=" [decimal]]
					[" maxVal=" [decimal] ] ">" [exp-id] "</export>"
					[exp-id] ::= [goal-id] | [task-id] | 
					[predicate-id] | [variable-id] | [qual-id]

[initializations]::= "<initializations> " [initialization] "</initializations>"
[initialization]::= [b-init] | [d-init]
[b-init]		::= "<initialization element=" [predicate-id] "> "
					[boolean] "</initialization>"
[d-init]		::= "<initialization element=" [cont-init-id] "> "
					[decimal] "</initialization>"
[cont-init-id]	::= [variable-id] | [qual-id]
[definitions]	::= "<definitions>" [definition] "</definitions>"
[definition]	::= "<definition>" [definiendum] [definiens] "</definition>"
[definiendum]	::= "<definiendum name = ‘" [identifier] "’>"
					[ [parameters] ] "</definiendum>"
[definiens]		::= "<definiens>" [boolean-expression] "</definiens>"
```
#### Invariants
```
[invariants]	::= "<invariants>" [invariant] "</invariants>"
[invariant]		::= "<invariant>" [temporal-formula] "</invariant>"
```
