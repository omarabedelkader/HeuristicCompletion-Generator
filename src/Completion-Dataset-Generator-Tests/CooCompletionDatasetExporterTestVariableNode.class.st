"
Mock
"
Class {
	#name : 'CooCompletionDatasetExporterTestVariableNode',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'instance creation' }
CooCompletionDatasetExporterTestVariableNode class >> named: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestVariableNode >> name [ 

	^ name
]

{ #category : 'accessing' }
CooCompletionDatasetExporterTestVariableNode >> name: aString [

	name := aString
]
