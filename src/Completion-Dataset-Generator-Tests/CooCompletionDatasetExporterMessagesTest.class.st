Class {
	#name : 'CooCompletionDatasetExporterMessagesTest',
	#superclass : 'TestCase',
	#instVars : [
		'tempDirectory',
		'noneContextFile',
		'completionContextFile'
	],
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'running' }
CooCompletionDatasetExporterMessagesTest >> setUp [

	super setUp.
	tempDirectory := FileSystem workingDirectory / 'tmp' / 'ai-sorter-tests'.
	tempDirectory ensureCreateDirectory.
	noneContextFile := tempDirectory / 'completion-none.json'.
	completionContextFile := tempDirectory / 'completion-completion.json'
]

{ #category : 'running' }
CooCompletionDatasetExporterMessagesTest >> tearDown [

	{ noneContextFile. completionContextFile } do: [ :file |
		file ifNotNil: [
			file exists ifTrue: [ file delete ] ] ].
	tempDirectory ifNotNil: [
		tempDirectory exists ifTrue: [ tempDirectory deleteAll ] ].
	super tearDown
]

{ #category : 'running' }
CooCompletionDatasetExporterMessagesTest >> testExportOnPackagesWithDifferentContexts [

	CooCompletionDatasetExporterMessages
		exportOnPackages: #( 'AI-Sorter-Exporter' )
		heuristics: [ :builder | builder messageHeuristic ]
		context: #none
		to: noneContextFile fullName.

	CooCompletionDatasetExporterMessages
		exportOnPackages: #( 'AI-Sorter-Exporter' )
		heuristics: [ :builder | builder messageHeuristic ]
		context: #completion
		to: completionContextFile fullName.

	self assert: completionContextFile exists.
	self assert: completionContextFile size > 0.
	self deny: noneContextFile contents = completionContextFile contents
]

{ #category : 'running' }
CooCompletionDatasetExporterMessagesTest >> testExportOnPackagesWritesFile [

	CooCompletionDatasetExporterMessages
		exportOnPackages: #( 'AI-Sorter-Exporter' )
		heuristics: [ :builder | builder messageHeuristic ]
		context: #none
		to: noneContextFile fullName.

	self assert: noneContextFile exists.
	self assert: noneContextFile size > 0
]
