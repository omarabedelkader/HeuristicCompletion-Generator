"
context
"
Class {
	#name : 'CooCompletionDatasetExporterMessagesTestExporter',
	#superclass : 'CooCompletionDatasetExporterMessages',
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessagesTestExporter >> buildCompletionFor: aMessageNode atPosition: aPosition [

	"Avoid invoking the completion engine during tests."
	^ nil
]

{ #category : 'benchmarks' }
CooCompletionDatasetExporterMessagesTestExporter >> fetchTopCandidatesFrom: aCompletion usingPrefix: aPrefix [

	"Return empty candidates to keep tests hermetic."
	^ #()
]
