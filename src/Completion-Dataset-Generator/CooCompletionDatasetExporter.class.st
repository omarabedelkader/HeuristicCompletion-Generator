"
I manage dataset export runs for code completion benchmarks.

	Subclasses define how to build completion contexts and candidates for a
	specific callsite type (e.g. messages or variables). Instances collect
	entries with the completion context, candidate list, and correct answer,
	then serialize the results to JSON for storage on disk
"
Class {
	#name : 'CooCompletionDatasetExporter',
	#superclass : 'CooStaticBenchmarks',
	#instVars : [
		'entries',
		'contextStrategy'
	],
	#category : 'Completion-Dataset-Generator',
	#package : 'Completion-Dataset-Generator'
}

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter class >> exportOnPackages: aCollectionOfPackages heuristics: aHeuristicsBlock context: aContextStrategy to: aPathString [ 

	| exporter |
	exporter := self new
		            builder: CoASTHeuristicsResultSetBuilder new;
		            contextStrategy: aContextStrategy;
		            yourself.

	aHeuristicsBlock ifNotNil: [ aHeuristicsBlock value: exporter builder ].

	aCollectionOfPackages do: [ :packageOrName |
		| package |
		package := packageOrName isString
			           ifTrue: [ PackageOrganizer default packageNamed: packageOrName ]
			           ifFalse: [ packageOrName ].
		package ifNil: [ ^ self error: 'Package not found: ' , packageOrName printString ].

		exporter scope: (CoBenchmarkPackage on: package).
		exporter run ].

	exporter writeToFileNamed: aPathString.
	^ exporter
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter >> benchCallsite: aMessageNode inMethod: aMethod atPosition: aPosition [ 
	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter >> completionContextFor: aMessageNode withPrefix: prefix [ 
	^ self subclassResponsibility
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter >> contextFor: aMessageNode inMethod: aMethod atPosition: aPosition withPrefix: prefix [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> contextStrategy [

	^ contextStrategy
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> contextStrategy: aSymbol [

	contextStrategy := aSymbol
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entries [

	^ entries
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> entriesAsJsonString [

	^ NeoJSONWriter toString: (entries collect: [ :entry |
		   Dictionary new
			   at: 'context' put: (entry at: #context);
			   at: 'candidates' put: (entry at: #candidates);
			   at: 'correct' put: (entry at: #correct);
			   yourself ])
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> initialize [

	super initialize.
	entries := OrderedCollection new
]

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporter >> lineCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix [
	| source position endIndex lastLf lastCr lineStart linePrefix |

	source := aNode methodNode source.

	position := (aPosition respondsTo: #first)
		ifTrue: [ aPosition first ]
		ifFalse: [ aPosition ].

	position := position max: 1.
	position := position min: source size + 1.
	endIndex := position - 1.

	lastLf := endIndex < 1
		ifTrue: [ 0 ]
		ifFalse: [
			source
				lastIndexOf: Character lf
				startingAt: endIndex
				ifAbsent: [ 0 ] ].

	lastCr := endIndex < 1
		ifTrue: [ 0 ]
		ifFalse: [
			source
				lastIndexOf: Character cr
				startingAt: endIndex
				ifAbsent: [ 0 ] ].

	lineStart := (lastLf max: lastCr) + 1.
	lineStart := lineStart max: 1.

	linePrefix := endIndex < lineStart
		ifTrue: [ '' ]
		ifFalse: [ source copyFrom: lineStart to: endIndex ].

	^ linePrefix , prefix

]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> recordContext: context candidates: candidates correct: originalValue [

	entries add: (Dictionary new
			 at: #context put: context;
			 at: #candidates put: (candidates collect: [ :each | each contents ]);
			 at: #correct put: originalValue;
			 yourself)
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> sourceForNode: aNode inMethodSource: source [

	| interval |
	(aNode isNil or: [ source isNil ]) ifTrue: [ ^ '' ].

	interval := (aNode respondsTo: #sourceInterval)
		            ifTrue: [ aNode sourceInterval ]
		            ifFalse: [ nil ].
	(interval notNil and: [ interval size >= 2 ]) ifTrue: [
		^ source copyFrom: interval first to: interval last ].

	^ aNode printString
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> surroundingCompletionContextFor: aNode atPosition: aPosition withPrefix: prefix [

	| source position endIndex prefixContext |
	source := aNode methodNode source.
	position := (aPosition respondsTo: #first)
		            ifTrue: [ aPosition first ]
		            ifFalse: [ aPosition ].
	position := position max: 1.
	position := position min: source size + 1.
	endIndex := position - 1.

	prefixContext := endIndex < 1
		                 ifTrue: [ '' ]
		                 ifFalse: [ source copyFrom: 1 to: endIndex ].
	^ prefixContext , prefix
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> writeToFileNamed: aString [

	| reference |
	reference := aString asFileReference.
	reference parent ensureCreateDirectory.
	reference writeStreamDo: [ :stream |
		stream
			truncate;
			nextPutAll: self entriesAsJsonString ]
]

{ #category : 'accessing' }
CooCompletionDatasetExporter >> writeToFileReference: aFileReference [

	aFileReference writeStreamDo: [ :stream |
		stream
			truncate;
			nextPutAll: self entriesAsJsonString ]
]
