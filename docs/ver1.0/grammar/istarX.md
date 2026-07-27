### Primitives, Enums
##### BNF
```
[letter] 		::= "A" | "B" | ... | "Z" | "a" | "b" | ... | "z"
[letter-small]	::= "a" | "b" | ... | "z"
[digit] 		::= "0" | "1" | ... | "9"
[alphanum] 		::= [letter] | [digit] | " "
[identifier] 	::= [letter-small][alphanum]*
[comparison-op] ::= "gt" | "gte" | "lt" | "lte" | "eq" | "neq"
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

### Parameters
##### BNF
```
[parameters] 	::= "<parameters>" [parameter]+ "</parameters>"
[parameter] 	::= "<parameter>" [ [param-type] ] [param-name] "</parameter>"
[param-type] 	::= "<paramType>" [identifier] "</paramType>"
[param-name] 	::= "<paramName>" [identifier] "</paramName>"
```
##### XSD
```xml
<xs:complexType name="parametersType">
  <xs:sequence>
    <xs:element name="parameter" type="idn:parameterType" maxOccurs="unbounded"/>
  </xs:sequence>
</xs:complexType>
<xs:element name="parameters" type="idn:parametersType"/>

<xs:complexType name="parameterType">
  <xs:sequence>
    <xs:element name="paramType" type="idn:identifier" minOccurs="0" />
    <xs:element name="paramName" type="idn:identifier"/>
  </xs:sequence>
</xs:complexType>
```

#### Predicates and Variables

##### BNF
```
[predicates]	::= "<predicates>" [predicate]+ "</predicates>"
[predicate]		::= "<predicate name = ‘" [identifier] "’" ["description =‘" [xs:string] "’] >"
					[ [parameters] ] "</predicate>" % see above
[variables] 	::= "<variables>" [variable]+ "</variables>"
[variable]		::= "<variable name = ‘" [identifier] "’" ["description =‘" [xs:string] "’] >"
					"</variable>"
```
##### XSD
```xml
<!-- ============ predicates ============ -->

<xs:complexType name="predicateType">
  <xs:sequence>
    <xs:element ref="idn:parameters" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
  <xs:attribute name="description" type="xs:string" use="optional"/>
</xs:complexType>

<!-- single element, used both for declarations under <predicates> and as an atom reference -->
<xs:element name="predicate" type="idn:predicateType" substitutionGroup="idn:atomBool"/>


<xs:element name="predicates">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:predicate" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- ============ variables ============ -->

<xs:complexType name="variableType">
  <xs:attribute name="name" type="idn:identifier" use="required"/>
  <xs:attribute name="description" type="xs:string" use="optional"/>
</xs:complexType>

<!-- single element, used both for declarations under <variables> and as a reference -->
<xs:element name="variable" type="idn:variableType" substitutionGroup="idn:numericExpression"/>

<xs:element name="variables">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:variable" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```


### Boolean Expressions
##### BNF
```
[boolean-expression] 	::= [bool-const] | [atom-bool] | [numeric-comparison] | [boolean-operation]
[bool-const] 			::= "<boolConst>" [xs:boolean] "</boolConst>"
[atom-bool]				::= [predicate] | [goal-ref] | [task-ref] | [defn-ref]
[boolean-operation] 	::= [and] | [or] | [not] | [implies] | [prev-bool]
[and] 					::= "<and>" [boolean-expression] [boolean-expression]+ "</and>"
[or] 					::= "<or>" [boolean-expression] [boolean-expression]+ "</or>"
[not] 					::= "<not>" [boolean-expression] "</not>"
[implies] 				::= "<implies>" [boolean-expression] [boolean-expression] "</implies>"
[prev-bool] 			::= "<previousBool>" [atom-bool] "</previousBool>"
[numeric-comparison] 	::= "<" [comparison-op] ">"
							"<left>" [numeric-expression] "</left>"
							"<right>" [numeric-expression] "</right>"
							"</" [comparison-op] ">"
```

##### XSD
```xml
<!-- Abstract head: every concrete expression node substitutes for this -->
<xs:element name="booleanExpression" type="xs:anyType" abstract="true"
	            substitutionGroup="idn:temporalFormula"/>


	<!-- [bool-const] Def -->
	<xs:element name="boolConst" substitutionGroup="idn:booleanExpression" type="xs:boolean"/>

	<!-- [atom-bool] Def -->
	<xs:element name="atomBool" abstract="true" substitutionGroup="idn:booleanExpression"/>

	<!-- [boolean-operation] Def / n-ary case -->
	<xs:complexType name="naryBooleanOp">
	  <xs:sequence>
	    <xs:element ref="idn:booleanExpression" minOccurs="2" maxOccurs="unbounded"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="and" substitutionGroup="idn:booleanExpression" type="idn:naryBooleanOp"/>
	<xs:element name="or"  substitutionGroup="idn:booleanExpression" type="idn:naryBooleanOp"/>

	<!-- [boolean-operation] Def / unary case (not) -->
	<xs:complexType name="notOp">
	  <xs:sequence>
	    <xs:element ref="idn:booleanExpression"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="not" substitutionGroup="idn:booleanExpression" type="idn:notOp"/>

	<!-- [boolean-operation] Def / binary case (implies) -->
	<xs:complexType name="impliesOp">
	  <xs:sequence>
	    <xs:element ref="idn:booleanExpression"/>
	    <xs:element ref="idn:booleanExpression"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="implies" substitutionGroup="idn:booleanExpression" type="idn:impliesOp"/>

	<!-- [boolean-operation] Def / unary case with atom-bool (prev-bool) -->
	<xs:complexType name="previousBoolOp">
	  <xs:sequence>
	    <xs:element ref="idn:atomBool"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="previousBool" substitutionGroup="idn:booleanExpression" type="idn:previousBoolOp"/>

	<!-- [numeric-comparison] Def -->
	<xs:complexType name="comparisonType">
	  <xs:sequence>
	    <xs:element name="left">
	      <xs:complexType><xs:group ref="idn:numericExpressionOrAtomBool"/></xs:complexType>
	    </xs:element>
	    <xs:element name="right">
	      <xs:complexType><xs:group ref="idn:numericExpressionOrAtomBool"/></xs:complexType>
	    </xs:element>
	  </xs:sequence>
	  <xs:attribute name="op" type="idn:comparisonOp" use="required"/>
	</xs:complexType>
	<xs:element name="numericComparison" substitutionGroup="idn:booleanExpression" type="idn:comparisonType"/>
```
### Numeric Expressions
##### BNF
```
[numeric-expression] 	::= [num-const] | [num-atom] | [previous] |
							[arithmetic-operation]
[num-const] 			::= "<numConst>" [xs:decimal] "</numConst>"
[num-atom] 				::= [atom-bool] | [variable] | [quality-ref]
[previous] 				::= "<previous>" [num-atom] "</previous>"
[arithmetic-operation] 	::= [add] | [subtract] | [multiply] | [divide]
[add] 					::= "<add>" [numeric-expression] [numeric-expression]+ "</add>"
[multiply] 				::= "<multiply>" [numeric-expression] [numeric-expression]+
							"</multiply>"
[subtract] 				::= "<subtract>" "<left>" [numeric-expression] "</left>"
							"<right>" [numeric-expression] "</right>" "</subtract>"
[divide] 				::= "<divide>" "<left>" [numeric-expression] "</left>"
							"<right>" [numeric-expression] "</right>" "</divide>"
```
##### XSD
```xml
<!-- Abstract head: numeric-expression (variable, quality, numConst, previous, 
     add/multiply/subtract/divide substitute this directly — predicate cannot, so it's 
     added explicitly via the group below wherever needed) -->
<xs:element name="numericExpression" type="xs:anyType" abstract="true"/>

	<!-- [num-const] -->
	<xs:element name="numConst" substitutionGroup="idn:numericExpression" type="xs:decimal"/>

	<!-- reusable fragment: boolean atom | variable | quality, used inside <previous> -->
	<xs:group name="numAtomGroup">
	  <xs:choice>
	    <xs:element ref="idn:atomBool"/>
	    <xs:element ref="idn:variable"/>
	    <xs:element ref="idn:qualityRef"/>
	  </xs:choice>
	</xs:group>


	<!-- [previous] -->
	<xs:complexType name="previousOp">
	  <xs:group ref="idn:numAtomGroup"/>
	</xs:complexType>
	<xs:element name="previous" substitutionGroup="idn:numericExpression" type="idn:previousOp"/>

	<!-- reusable fragment: any numeric-expression, OR a bare predicate (1/0) -->

	<xs:group name="numericExpressionOrAtomBool">
	  <xs:choice>
	    <xs:element ref="idn:numericExpression"/>
	    <xs:element ref="idn:atomBool"/>
	  </xs:choice>
	</xs:group>

	<!-- [arithmetic-operation] / n-ary case: add, multiply -->
	<xs:complexType name="naryArithmeticOp">
	  <xs:sequence>
	    <xs:group ref="idn:numericExpressionOrAtomBool" minOccurs="2" maxOccurs="unbounded"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="add"      substitutionGroup="idn:numericExpression" type="idn:naryArithmeticOp"/>
	<xs:element name="multiply" substitutionGroup="idn:numericExpression" type="idn:naryArithmeticOp"/>

	<!-- [arithmetic-operation] / binary case: subtract, divide -->
	<xs:complexType name="binaryArithmeticOp">
	  <xs:sequence>
	    <xs:element name="left">
	      <xs:complexType><xs:group ref="idn:numericExpressionOrAtomBool"/></xs:complexType>
	    </xs:element>
	    <xs:element name="right">
	      <xs:complexType><xs:group ref="idn:numericExpressionOrAtomBool"/></xs:complexType>
	    </xs:element>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="subtract" substitutionGroup="idn:numericExpression" type="idn:binaryArithmeticOp"/>
	<xs:element name="divide"   substitutionGroup="idn:numericExpression" type="idn:binaryArithmeticOp"/>
```

### Temporal Formulae
##### BNF
```
[temporal-formula] ::= [boolean-expression]
[temporal-formula] ::= "<always>" [temporal-formula] "</always>"
[temporal-formula] ::= "<eventually>" [temporal-formula] "</eventually>"
[temporal-formula] ::= "<next>" [temporal-formula] "</next>"
[temporal-formula] ::= "<until><left>" [temporal-formula] "</left> <right> "[temporal-formula] "</right></until>"
```

##### XSD
```xml
<!-- Abstract head: temporal-formula -->
<xs:element name="temporalFormula" type="xs:anyType" abstract="true"/>

	<!-- [temporal-formula] ::= [boolean-expression] -->
	<!-- booleanExpression already exists as its own abstract head; making it a member
	     of temporalFormula's group means all its existing members (boolConst, and, or,
	     not, implies, previousBool, numericComparison) are transitively valid here too -->
	

	<!-- [always] -->
	<xs:complexType name="alwaysOp">
	  <xs:sequence>
	    <xs:element ref="idn:temporalFormula"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="always" substitutionGroup="idn:temporalFormula" type="idn:alwaysOp"/>

	<!-- [eventually] -->
	<xs:complexType name="eventuallyOp">
	  <xs:sequence>
	    <xs:element ref="idn:temporalFormula"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="eventually" substitutionGroup="idn:temporalFormula" type="idn:eventuallyOp"/>

	<!-- [next] -->
	<xs:complexType name="nextOp">
	  <xs:sequence>
	    <xs:element ref="idn:temporalFormula"/>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="next" substitutionGroup="idn:temporalFormula" type="idn:nextOp"/>

	<!-- [until] -->
	<xs:complexType name="untilOp">
	  <xs:sequence>
	    <xs:element name="left">
	      <xs:complexType>
	        <xs:sequence>
	          <xs:element ref="idn:temporalFormula"/>
	        </xs:sequence>
	      </xs:complexType>
	    </xs:element>
	    <xs:element name="right">
	      <xs:complexType>
	        <xs:sequence>
	          <xs:element ref="idn:temporalFormula"/>
	        </xs:sequence>
	      </xs:complexType>
	    </xs:element>
	  </xs:sequence>
	</xs:complexType>
	<xs:element name="until" substitutionGroup="idn:temporalFormula" type="idn:untilOp"/>
```
### Goals
##### BNF
```
[goals] 		::= "<goals>" [goal]+ "</goals>"
[goal] 			::= "<goal name=‘" [identifier] "’ mode = " [goal-mode]
					[" root = ‘" [boolean] "’"] [" activationStyle = " [act-style] "]
					[" description=‘" [xs:string] "’"] [" terminal=‘" [xs:boolean] "’"]
					[" episodeLength=‘" [xs:nonNegativeInteger] "’"] [" actor=‘" [identifier] "’"]
					[goal-content] "</goal>"
[goal-mode] 	::= ‘achieve’ | ‘maintain" | ‘avoid’
[act-style] 	::= ‘called’ | ‘triggered’
[goal-content]	::= [ [parameters] ] [ [pre] ] [ [tri] ] [ [goal-defn] ] [ [refinement] ]
[pre]			::= "<pre>" [boolean-expression] "</pre>"
[tri]			::= "<tri>" [boolean-expression] "</tri>"
[goal-defn]		::= "<goalDefn>" [activation] [fulfillment] "</goalDefn>"
[activation]	::= "<activation>" [boolean-expression] "</activation>"
[fulfillment]	::= "<fulfillment>" [boolean-expression] "</fulfillment>"
[refinement]	::= "<refinement type=‘" [ref-type] "’>"
					[ [ref-condition] ]
					([childGoal] | [childTask])+ "</refinement>"
[ref-type]		::= "AND" | "OR"
[ref-condition]	::= "<refCondition>" [pick-cond] | [forall-cond] "</refCondition>"
[pick-cond]		::= "<pick>" [cond-content] "</pick>"
[forall-cond]	::= "<forall>" [cond-content] "</forall>"
[cond-content]	::= "<params>" [cond-param]+ "</params>"
					"<condition>" [predicate] "</condition>"
[cond-param]	::= "<param>" [identifier] "</param>"
[childGoal]		::= [goal-ref]
[childTask]		::= [task-ref]
[goal-ref]		::= "<goalRef name=‘" [identifier] "’>"[ [parameters] ]"</goalRef>"
```

##### XSD
```xml
<!-- ============ Goals ============ -->

<xs:simpleType name="goalMode">
  <xs:restriction base="xs:string">
    <xs:enumeration value="achieve"/>
    <xs:enumeration value="maintain"/>
    <xs:enumeration value="avoid"/>
  </xs:restriction>
</xs:simpleType>

<xs:simpleType name="actStyle">
  <xs:restriction base="xs:string">
    <xs:enumeration value="called"/>
    <xs:enumeration value="triggered"/>
  </xs:restriction>
</xs:simpleType>

<xs:simpleType name="refType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="AND"/>
    <xs:enumeration value="OR"/>
  </xs:restriction>
</xs:simpleType>

<!-- [pre] -->
<xs:complexType name="preType">
  <xs:sequence>
    <xs:element ref="idn:booleanExpression"/>
  </xs:sequence>
</xs:complexType>
<xs:element name="pre" type="idn:preType"/>

<!-- [tri] -->
<xs:complexType name="triType">
  <xs:sequence>
    <xs:element ref="idn:booleanExpression"/>
  </xs:sequence>
</xs:complexType>
<xs:element name="tri" type="idn:triType"/>

<!-- [activation] / [fulfillment] -->
<xs:complexType name="activationType">
  <xs:sequence>
    <xs:element ref="idn:booleanExpression"/>
  </xs:sequence>
</xs:complexType>
<xs:element name="activation" type="idn:activationType"/>

<xs:complexType name="fulfillmentType">
  <xs:sequence>
    <xs:element ref="idn:booleanExpression"/>
  </xs:sequence>
</xs:complexType>
<xs:element name="fulfillment" type="idn:fulfillmentType"/>

<!-- [goal-defn] -->
<xs:complexType name="goalDefnType">
  <xs:sequence>
    <xs:element ref="idn:activation"/>
    <xs:element ref="idn:fulfillment"/>
  </xs:sequence>
</xs:complexType>
<xs:element name="goal-defn" type="idn:goalDefnType"/>

<!-- [cond-param] -->
<xs:element name="param" type="idn:identifier"/>

<!-- [cond-content] -->
<xs:complexType name="condContentType">
  <xs:sequence>
    <xs:element name="params">
      <xs:complexType>
        <xs:sequence>
          <xs:element ref="idn:param" maxOccurs="unbounded"/>
        </xs:sequence>
      </xs:complexType>
    </xs:element>
    <xs:element name="condition">
      <xs:complexType>
        <xs:sequence>
          <xs:element ref="idn:predicate"/>
        </xs:sequence>
      </xs:complexType>
    </xs:element>
  </xs:sequence>
</xs:complexType>

<!-- [pick-cond] / [forall-cond] -->
<xs:element name="pick" type="idn:condContentType"/>
<xs:element name="forall" type="idn:condContentType"/>

<!-- [ref-condition]: choice of pick | forall -->
<xs:element name="ref-condition">
  <xs:complexType>
    <xs:choice>
      <xs:element ref="idn:pick"/>
      <xs:element ref="idn:forall"/>
    </xs:choice>
  </xs:complexType>
</xs:element>

<!-- [goal]: full declaration — lives under <goals> -->
<xs:complexType name="goalType">
  <xs:sequence>
    <xs:element ref="idn:parameters" minOccurs="0"/>
    <xs:element ref="idn:pre" minOccurs="0"/>
    <xs:element ref="idn:tri" minOccurs="0"/>
    <xs:element ref="idn:goal-defn" minOccurs="0"/>
    <xs:element ref="idn:refinement" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
  <xs:attribute name="mode" type="idn:goalMode" use="required"/>
  <xs:attribute name="root" type="xs:boolean" use="optional"/>
  <xs:attribute name="activationStyle" type="idn:actStyle" use="optional"/>
  <xs:attribute name="description" type="xs:string" use="optional"/>
  <xs:attribute name="terminal" type="xs:boolean" use="optional"/>
  <xs:attribute name="episodeLength" type="xs:nonNegativeInteger" use="optional"/>
  <xs:attribute name="actor" type="idn:identifier" use="optional"/>
</xs:complexType>
<xs:element name="goal" type="idn:goalType"/>

<xs:element name="goals">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:goal" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- [goal-ref]: lightweight reference — name + parameters only.
     Substitutes atomBool, so a goalRef is usable directly in boolean-expressions,
     and (transitively, via booleanExpression -> temporalFormula) in temporal formulae too. -->
<xs:complexType name="goalRefType">
  <xs:sequence>
    <xs:element ref="idn:parameters" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
</xs:complexType>
<xs:element name="goalRef" substitutionGroup="idn:atomBool" type="idn:goalRefType"/>

<!-- [refinement] — childGoal uses the lightweight goalRef, not the full goal -->
<xs:complexType name="refinementType">
  <xs:sequence>
    <xs:element ref="idn:ref-condition" minOccurs="0"/>
    <xs:choice minOccurs="1" maxOccurs="unbounded">
      <xs:element ref="idn:goalRef"/>   <!-- childGoal -->
      <xs:element ref="idn:taskRef"/>   <!-- childTask -->
    </xs:choice>
  </xs:sequence>
  <xs:attribute name="type" type="idn:refType" use="required"/>
</xs:complexType>
<xs:element name="refinement" type="idn:refinementType"/>
```
### Tasks
##### BNF
```
[tasks]			::= "<tasks>" [task]+ "</tasks>"
[task]			::= "<task name=‘" [identifier] "’" [" description=‘" [xs:string] "’"]
					[" actor=‘" [identifier] "’"] [" activationStyle =" [act-style] "] ">" 
					[task-content] "</task>"
[task-content]	::= [ [parameters] ] [effectGroup] [ [pre] ] [ [tri] ]
[effectGroup]	::= "<effectGroup>" [effect]+ "</effectGroup>"
[effect]		::= "<effect name=‘" [identifier] "’" [ " satisfying=‘" [xs:boolean] "’" ]
					" probability=‘" [xs:decimal] "’" [ " description=‘" [xs:string] "’" ]
					">" [effect-content] "</effect>"
[effect-content]::= [ [turnsTrue]* ] [ [turnsFalse]* ] [ [sets]* ] [ [pre] ]
[turnsTrue]		::= "<turnsTrue>" [predicate] "</turnsTrue>"
[turnsFalse]	::= "<turnsFalse>" [predicate] "</turnsFalse>"
[sets]			::= "<set>" [variable] [num-const] "</set>"
[task-ref]		::= "<taskRef name=‘" [identifier] "’>"[ [parameters] ]"</taskRef>"
```
##### XSD
```xml
<!-- ============ Tasks ============ -->

<!-- [turnsTrue] / [turnsFalse] -->
<xs:element name="turnsTrue">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:predicate"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<xs:element name="turnsFalse">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:predicate"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- [sets] -->
<xs:element name="set">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:variable"/>
      <xs:element ref="idn:numConst"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- [effect-content] -->
<xs:complexType name="effectContentType">
  <xs:sequence>
    <xs:element ref="idn:turnsTrue" minOccurs="0" maxOccurs="unbounded"/>
    <xs:element ref="idn:turnsFalse" minOccurs="0" maxOccurs="unbounded"/>
    <xs:element ref="idn:set" minOccurs="0" maxOccurs="unbounded"/>
    <xs:element ref="idn:pre" minOccurs="0"/>
  </xs:sequence>
</xs:complexType>

<!-- [effect] -->
<xs:complexType name="effectType">
  <xs:complexContent>
    <xs:extension base="idn:effectContentType">
      <xs:attribute name="name" type="idn:identifier" use="required"/>
      <xs:attribute name="satisfying" type="xs:boolean" use="optional"/>
      <xs:attribute name="probability" type="xs:decimal" use="required"/>
      <xs:attribute name="description" type="xs:string" use="optional"/>
    </xs:extension>
  </xs:complexContent>
</xs:complexType>
<xs:element name="effect" type="idn:effectType"/>

<!-- [effectGroup] -->
<xs:complexType name="effectGroupType">
  <xs:sequence>
    <xs:element ref="idn:effect" maxOccurs="unbounded"/>
  </xs:sequence>
</xs:complexType>
<xs:element name="effectGroup" type="idn:effectGroupType"/>

<!-- [task]: full declaration — lives under <tasks> -->
<xs:complexType name="taskType">
  <xs:sequence>
    <xs:element ref="idn:parameters" minOccurs="0"/>
    <xs:element ref="idn:effectGroup"/>
    <xs:element ref="idn:pre" minOccurs="0"/>
    <xs:element ref="idn:tri" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
  <xs:attribute name="description" type="xs:string" use="optional"/>
  <xs:attribute name="actor" type="idn:identifier" use="optional"/>
  <xs:attribute name="activationStyle" type="idn:actStyle" use="optional"/>
</xs:complexType>
<xs:element name="task" type="idn:taskType"/>

<xs:element name="tasks">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:task" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- [task-ref]: lightweight reference — name + parameters only, distinct tag <taskRef>.
     Substitutes atomBool, symmetric with goalRef, so a taskRef is usable
     directly in boolean-expressions / temporal formulae, and as childTask in refinement. -->
<xs:complexType name="taskRefType">
  <xs:sequence>
    <xs:element ref="idn:parameters" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
</xs:complexType>
<xs:element name="taskRef" substitutionGroup="idn:atomBool" type="idn:taskRefType"/>
```
#### Qualities
##### BNF
```
[qualities]	::= "<qualities>" [quality]+ "</qualities>"
[quality]	::= "<quality name=‘" [identifier] "’" [" description=‘" [xs:string] "’"] [" root=‘" [xs:boolean] "’"] ">"
				[numeric-expression] "</quality>"
[qualityRef]::= "<qualityRef name=‘" [identifier] "’ ></qualityRef>"
```
##### XSD
```xml
<!-- ============ Qualities ============ -->

<!-- [quality]: full declaration — lives under <qualities> -->
<xs:complexType name="qualityType">
  <xs:sequence>
    <xs:element ref="idn:numericExpression"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
  <xs:attribute name="description" type="xs:string" use="optional"/>
  <xs:attribute name="root" type="xs:boolean" use="optional"/>
</xs:complexType>
<xs:element name="quality" type="idn:qualityType"/>

<xs:element name="qualities">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:quality" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<xs:complexType name="qualityRefType">
  <xs:attribute name="name" type="idn:identifier" use="required"/>
</xs:complexType>
<xs:element name="qualityRef" substitutionGroup="idn:numericExpression" type="idn:qualityRefType"/>
```

### Invariants
##### BNF
```
[invariants]	::= "<invariants>" [invariant]+ "</invariants>"
[invariant]		::= "<invariant>" [temporal-formula] "</invariant>"
```
##### XSD
```xml
<!-- ============ Invariants ============ -->
<xs:element name="invariant">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:temporalFormula"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<xs:element name="invariants">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:invariant" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
```

------------------

#### Cross-runs, Exported Sets, Initializations, Definitions
##### BNF
```
[cross-runs]	::= "<crossRuns>" [cross-run]+ "</crossRuns>"
[cross-run]		::= "<crossRun>" [predicate] | [variable] | [quality-ref]
					"</crossRun>"
					
[exported-set]	::= "<exportedSet>" [export]+ "</exportedSet>"
[export]		::= "<export continuous=" [boolean] [ "minVal=" [xs:decimal]]
					[" maxVal=" [xs:decimal] ] ">" [exp-id] "</export>"
[exp-id]		::= [goal-ref] | [task-ref] | [quality-ref] | [predicate] | [variable]

[initializations]::= "<initializations> " [initialization]+ "</initializations>"
[initialization]::= [b-init] | [d-init]
[b-init]		::= "<boolInit value=" [xs:boolean] "> "
					[predicate] "</boolInit>"
[d-init]		::= "<numInit value=" [xs:decimal] "> "
					[cont-init-id] "</numInit>"
[cont-init-id]	::= [variable] | [quality-ref]

[definitions]	::= "<definitions>" [definition]+ "</definitions>"
[definition]	::= "<definition>" [definiendum] [definiens] "</definition>"
[definiendum]	::= "<definiendum name = ‘" [identifier] "’>"
					[ [parameters] ] "</definiendum>"
[definiens]		::= "<definiens>" [boolean-expression] "</definiens>"
[defn-ref]		::= "<defnRef name = ‘" [identifier] "’>" [ [parameters] ] "</defnRef>"
```
##### XSD
```xml
<!-- ============ Cross-Runs ============ -->

<xs:group name="crossRunAtomGroup">
  <xs:choice>
    <xs:element ref="idn:predicate"/>
    <xs:element ref="idn:variable"/>
    <xs:element ref="idn:qualityRef"/>
  </xs:choice>
</xs:group>

<xs:element name="crossRun">
  <xs:complexType>
    <xs:group ref="idn:crossRunAtomGroup"/>
  </xs:complexType>
</xs:element>

<xs:element name="crossRuns">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:crossRun" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- ============ Exported Set ============ -->

<xs:group name="expIdGroup">
  <xs:choice>
    <xs:element ref="idn:goalRef"/>
    <xs:element ref="idn:taskRef"/>
    <xs:element ref="idn:qualityRef"/>
    <xs:element ref="idn:predicate"/>
    <xs:element ref="idn:variable"/>
  </xs:choice>
</xs:group>

<xs:element name="export">
  <xs:complexType>
    <xs:group ref="idn:expIdGroup"/>
    <xs:attribute name="continuous" type="xs:boolean" use="required"/>
    <xs:attribute name="minVal" type="xs:decimal" use="optional"/>
    <xs:attribute name="maxVal" type="xs:decimal" use="optional"/>
  </xs:complexType>
</xs:element>

<xs:element name="exportedSet">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:export" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- ============ Initializations ============ -->

<xs:group name="contInitIdGroup">
  <xs:choice>
    <xs:element ref="idn:variable"/>
    <xs:element ref="idn:qualityRef"/>
  </xs:choice>
</xs:group>

<xs:element name="boolInit">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:predicate"/>
    </xs:sequence>
    <xs:attribute name="value" type="xs:boolean" use="required"/>
  </xs:complexType>
</xs:element>

<xs:element name="numInit">
  <xs:complexType>
    <xs:group ref="idn:contInitIdGroup"/>
    <xs:attribute name="value" type="xs:decimal" use="required"/>
  </xs:complexType>
</xs:element>

<xs:element name="initializations">
  <xs:complexType>
    <xs:sequence>
      <xs:choice maxOccurs="unbounded">
        <xs:element ref="idn:boolInit"/>
        <xs:element ref="idn:numInit"/>
      </xs:choice>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- ============ Definitions ============ -->

<xs:complexType name="definiendumType">
  <xs:sequence>
    <xs:element ref="idn:parameters" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
</xs:complexType>
<xs:element name="definiendum" type="idn:definiendumType"/>

<xs:element name="definiens">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:booleanExpression"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<xs:element name="definition">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:definiendum"/>
      <xs:element ref="idn:definiens"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<xs:element name="definitions">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:definition" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- [defn-ref]: lightweight reference — name + optional parameters.
     Substitutes atomBool per your confirmation, so it's usable in boolean-expressions
     (and transitively in temporal formulae, numeric-expression atom contexts, etc.) -->
<xs:complexType name="defnRefType">
  <xs:sequence>
    <xs:element ref="idn:parameters" minOccurs="0"/>
  </xs:sequence>
  <xs:attribute name="name" type="idn:identifier" use="required"/>
</xs:complexType>
<xs:element name="defnRef" substitutionGroup="idn:atomBool" type="idn:defnRefType"/>
```


#### Root
##### BNF
```
[istardt-model] 	::= "<iStarX " [namespaces] ">" [model-header] [options] [actors] [ [predicates] ] 						
						[ [variables] ] [ [cross-runs] ] [ [exported-set] ] 
						[ [initializations] ] [ [definitions] ] [ [invariants] ]
						"</iStarX>"
[namespaces] 		::= " xmlns=‘" [xs:string] "’" [" xmlns:xsi=‘" [xs:string] "’]
						[" xsi:schemaLocation= ‘" [xs:string] "’"]
[model-header]		::= "<header title = ‘" [xs:string] "’ author = ‘" [xs:string]
						"’ source = ‘" [xs:string] "’ lastUpdated=‘" [xs:string] "’>"
						[xs:string] "</header>"
[options] 			::= "<options continuous = ‘" [xs:boolean] "’
						infeasibleActionPenalty = ‘" [xs:decimal] "’>
						</options>"
[actors] 			::= "<actors>" [actor]+ "</actors>"
[actor] 			::= "<actor " [actor-attributes] ">" [actor-content] "</actor>"
[actor-attributes]	::= "name=‘" [identifier] "’" [description=‘" [xs:string] "’]
[actor-content] 	::= [ [goals] ] [ [tasks] ] [ [qualities] ]
```

##### XSD
```xml
<!-- ============ Root ============ -->

<!-- [model-header]: four attributes + free-text content -->
<xs:complexType name="modelHeaderType">
  <xs:simpleContent>
    <xs:extension base="xs:string">
      <xs:attribute name="title" type="xs:string" use="required"/>
      <xs:attribute name="author" type="xs:string" use="required"/>
      <xs:attribute name="source" type="xs:string" use="required"/>
      <xs:attribute name="lastUpdated" type="xs:string" use="required"/>
    </xs:extension>
  </xs:simpleContent>
</xs:complexType>
<xs:element name="header" type="idn:modelHeaderType"/>

<!-- [options]: no children, two attributes -->
<xs:complexType name="optionsType">
  <xs:attribute name="continuous" type="xs:boolean" use="required"/>
  <xs:attribute name="infeasibleActionPenalty" type="xs:decimal" use="required"/>
</xs:complexType>
<xs:element name="options" type="idn:optionsType"/>

<!-- [actor-content]: per-actor concerns only -->
<xs:complexType name="actorContentType">
  <xs:sequence>
    <xs:element ref="idn:goals" minOccurs="0"/>
    <xs:element ref="idn:tasks" minOccurs="0"/>
    <xs:element ref="idn:qualities" minOccurs="0"/>
  </xs:sequence>
</xs:complexType>

<!-- [actor] -->
<xs:complexType name="actorType">
  <xs:complexContent>
    <xs:extension base="idn:actorContentType">
      <xs:attribute name="name" type="idn:identifier" use="required"/>
      <xs:attribute name="description" type="xs:string" use="optional"/>
    </xs:extension>
  </xs:complexContent>
</xs:complexType>
<xs:element name="actor" type="idn:actorType"/>

<xs:element name="actors">
  <xs:complexType>
    <xs:sequence>
      <xs:element ref="idn:actor" maxOccurs="unbounded"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

<!-- [istardt-model]: document root -->
<xs:complexType name="istardtModelType">
  <xs:sequence>
    <xs:element ref="idn:header"/>
    <xs:element ref="idn:options"/>
    <xs:element ref="idn:actors"/>
    <xs:element ref="idn:predicates" minOccurs="0"/>
    <xs:element ref="idn:variables" minOccurs="0"/>
    <xs:element ref="idn:crossRuns" minOccurs="0"/>
    <xs:element ref="idn:exportedSet" minOccurs="0"/>
    <xs:element ref="idn:initializations" minOccurs="0"/>
    <xs:element ref="idn:definitions" minOccurs="0"/>
    <xs:element ref="idn:invariants" minOccurs="0"/>
  </xs:sequence>
  <!-- xmlns / xmlns:xsi / xsi:schemaLocation are handled by XML namespace
       machinery itself, not declared here -->
</xs:complexType>
<xs:element name="iStarX" type="idn:istardtModelType"/>
```
