"
Mock
"
Class {
	#name : 'CooCompletionDatasetExporterTestCandidate',
	#superclass : 'Object',
	#instVars : [
		'contents'
	],
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'as yet unclassified' }
CooCompletionDatasetExporterTestCandidate class >> withContents: aString [

	^ self new
		  contents: aString;
		  yourself
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestCandidate >> contents [

	^ contents
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestCandidate >> contents: aString [

	contents := aString
]
