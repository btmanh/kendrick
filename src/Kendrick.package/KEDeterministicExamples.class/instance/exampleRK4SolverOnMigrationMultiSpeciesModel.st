examples
exampleRK4SolverOnMigrationMultiSpeciesModel
	"self new exampleRK4SolverOnMigrationMultiSpeciesModel"
	|model simulator graph db output cards|
	model := KEModel new.
	model population: KEMetaPopulation new.
	model population attributes: {#patch->((1 to: 15) asArray). #status->#(S E I R)}.
	cards := OrderedCollection newFrom: #(900 0 100 0).
	cards addAll: ([|c| c := OrderedCollection new.
							1 to: 14 do: [:i| c addAll: #(1000 0 0 0)]. c]) value.
	model buildFromCompartments: {#patch->((1 to: 15) asArray). #status->#(S E I R)} 
			cardinalities: cards.
	model addParameter: #beta inScope: (#patch->1) value: 0.75.
	model addParameter: #beta inScopes: ((2 to: 15) collect: [ :e| #patch->e ]) values: ((2 to: 15) collect: [:e| 0.5 ]).
	model addParameter: '{#v: 0.00274, #d: 0.0000365, #epsilon: 0.5, #gamma: 0.25, #N: #sizeOfPopulation}'.
	model configurations: { #sizeOfPopulation->#(#patch). #rescale->false }.
	
	graph := KEMigrationNetwork 
					newOn: model population 
					atAttribute: #patch topology: (KERandomSmallWorldNetwork new K: 2; beta: 0).
	graph strengthOfAllConnections: 0.03.
	graph addMigrationTransitionsTo: model.
	
	model addEquation: 'S:t=d*N-d*S-beta*S*I+v*R' parseAsAnEquation.
	model addEquation: 'E:t=beta*S*I-d*E-epsilon*E' parseAsAnEquation.
	model addEquation: 'I:t=epsilon*E-d*I-gamma*I' parseAsAnEquation.
	model addEquation: 'R:t=gamma*I-d*R-v*R' parseAsAnEquation.
		
	simulator := KESimulator new: #RungeKutta from: 0 to: 800 step: 1.
	simulator executeOn: model.
	output := simulator data.
	self halt.
	db := KEDiagramBuilder new.
	db data: (output dataAt: '{#status: #I}').
	db open
															
														