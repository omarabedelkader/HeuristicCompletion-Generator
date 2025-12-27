Class {
	#name : 'CooCompletionDatasetExporterTest',
	#superclass : 'TestCase',
	#category : 'Completion-Dataset-Generator-Tests',
	#package : 'Completion-Dataset-Generator-Tests'
}

{ #category : 'tests' }
CooCompletionDatasetExporterTest >> testEntriesAsJsonStringSerializesEntries [

	| exporter json data entry |
	exporter := CooCompletionDatasetExporter new.
	exporter
		recordContext: 'ctx'
		candidates: {
			CooCompletionDatasetExporterTestCandidate withContents: 'alpha'.
			CooCompletionDatasetExporterTestCandidate withContents: 'beta' }
		correct: 'answer'.

	json := exporter entriesAsJsonString.
	data := NeoJSONReader fromString: json.

	self assert: data size equals: 1.
	entry := data first.
	self assert: (entry at: 'context') equals: 'ctx'.
	self assert: (entry at: 'correct') equals: 'answer'.
	self assert: (entry at: 'candidates') asArray equals: #( 'alpha' 'beta' )
]

{ #category : 'tests' }
CooCompletionDatasetExporterTest >> testExportOnPackagesValidatesPackagesExist [

	| tempFile |
	tempFile := FileSystem workingDirectory / 'tmp' / 'ai-sorter-tests'
	            / 'missing-package.json'.

	self
		should: [
			CooCompletionDatasetExporter
				exportOnPackages: #( 'No-Such-Package-For-Test' )
				heuristics: nil
				context: #none
				to: tempFile fullName ]
		raise: Error.
	self deny: tempFile exists
]
