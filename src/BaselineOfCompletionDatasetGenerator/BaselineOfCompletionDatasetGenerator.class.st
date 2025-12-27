Class {
	#name : 'BaselineOfCompletionDatasetGenerator',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfCompletionDatasetGenerator',
	#package : 'BaselineOfCompletionDatasetGenerator'
}

{ #category : 'baselines' }
BaselineOfCompletionDatasetGenerator >> baseline: spec [

	<baseline>
	spec for: #common do: [
					spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

			spec
				baseline: 'ExtendedHeuristicCompletionBenchmarks'
				with: [ spec repository: 'github://omarabedelkader/HeuristicCompletion-Benchmarks/repository' ].

			spec package: 'Completion-Dataset-Generator'.
			spec package: 'Completion-Dataset-Generator-Tests' with: [ spec requires: #( 'Completion-Dataset-Generator' ) ] ]
]
