as yet unclassified
legends
	legends ifNil: [ 
		legends := OrderedCollection new.
		data do: [ :e|
			|str|
			str := ''.
			e key keysAndValuesDo: [ :k1 :v1|
				str := k1 asString, ': ', v1 asString, ',' 
				 ].
			str := str copyFrom: 1 to: (str size - 1).
			legends add: str 
			 ]
		 ].
	^ legends