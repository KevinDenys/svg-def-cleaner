sdc = require '../../bin/svg-def-cleaner'
describe "test d'intégration", ->
	it "nettoie les definitions dupliquées", ->
		fileContent = '<defs><b id="b">b</b><b id="ccc">b</b><d id="d">d</d><d id="e">d</d></defs><osef xlink:href="#b"/><osef xlink:href="#ccc" style="background:url(#ccc) #ccc" filter="url(#ccc)'
		expectedResult = '<defs><b id="b">b</b><d id="d">d</d></defs><osef xlink:href="#b"/><osef xlink:href="#b" style="background:url(#b) #ccc" filter="url(#b)'
		output = sdc.cleanSvgContent fileContent
		output.should.deep.equal expectedResult
	it "factorise les éléments dupliquées et réajusté par transformation", ->
		fileContent = '<defs><any id="a"/></defs><osef transform="any transformation"/><osef transform="another transformation"/><anything id="b">else</anything><osef transform="any transformation"/>'
		expectedResult = '<defs><any id="a"/><osef id="c"/></defs><use xlink:href="#c" transform="any transformation"/><use xlink:href="#c" transform="another transformation"/><anything id="b">else</anything><use xlink:href="#c" transform="any transformation"/>'
		output = sdc.cleanSvgContent fileContent
		output.should.deep.equal expectedResult
	it "enregistre la version nettoyé du fichier d'origine", ->
		sourceFile = 'test/demoFiles/filter-matrix-transform.svg'
		targetFile = 'test/demoFiles/filter-matrix-transform-generated.svg'
		controlFile = 'test/demoFiles/filter-matrix-transform-controlFile.svg'
		sdc.main sourceFile, targetFile
		cleanedContent = sdc.loadFile targetFile
		controlContent = sdc.loadFile controlFile
		cleanedContent.should.equal controlContent
