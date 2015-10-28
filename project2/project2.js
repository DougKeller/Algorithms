angular.module('dwk24', [])
.controller('ProjectController', function($rootScope, $scope, $filter) {
	function leaf(letter, weight) {
		return { value: letter, weight: weight }
	}

	function combine(left, right) {
		var node = {
			weight: left.weight + right.weight,
			left: left,
			right: right
		}

		return node
	}

	function buildTree(array) {
		if(array.length === 0)
			return null

		while(array.length > 1) {
			array.sort(function(a, b) {
				return a.weight - b.weight
			})
			array.splice(0, 2, combine(array[0], array[1]))
		}
		return array[0]
	}

	function traverse(tree, code) {
		if(tree.value) {
			$scope.nodes.push({ value: tree.value, code: code || '1' })
			$scope.codes[tree.value] = code || '1'
			return tree.value + '' + tree.weight
		}

		return traverse(tree.left, code + '0') + traverse(tree.right, code + '1') + '@' + tree.weight
	}

	function uint8toString(uint8str) {
		var base10 = parseInt(uint8str, 2)
		return String.fromCharCode(base10)
	}

	function encode() {
		$scope.encoded = ''
		var currentByte = ''
		var byteArray = []
		for(var i in $scope.encMessage) {
			var chr = $scope.encMessage[i], binary = $scope.codes[chr]
			currentByte += binary
			if(currentByte.length >= 8) {
				byteArray.push(currentByte.slice(0, 8))
				currentByte = currentByte.slice(8)
			}
		}
		while(currentByte.length % 8 !== 0)
			currentByte += '0'

		if(currentByte.length) 
			byteArray.push(currentByte)

		$scope.encoded = byteArray.join(' ')

		$scope.strEncode = ''
		byteArray.forEach(function(value) {
			$scope.strEncode += uint8toString(value)
		})
	}

	$scope.compress = function() {
		$scope.encMessage = $scope.encMessage || ''

		var freqs = {}
		for(var i in $scope.encMessage) {
			var chr = $scope.encMessage[i]
			freqs[chr] = (freqs[chr] || 0) + 1
		}

		$scope.nodes = Object.keys(freqs).map(function(key) { return leaf(key, freqs[key]) })

		var tree = buildTree($scope.nodes)

		$scope.nodes = []
		$scope.codes = {}
		$scope.traversal = tree ? (traverse(tree, '') + ';') : ''

		encode()
	}

	$scope.getBinary = function() {
		$scope.decoded = $scope.decMessage.split('').map(function(value) { return value.charCodeAt(0).toString(2) }).join(' ')
	}

	$scope.save = function() {
		$scope.fileName = $scope.fileName || 'compressed'
		var data = 'data:,' + encodeURIComponent($scope.strEncode)

		var downloadLink = document.createElement('a')
        downloadLink.href = data
        downloadLink.download = $scope.fileName + '.hzip'

        document.body.appendChild(downloadLink)
        downloadLink.click()
        document.body.removeChild(downloadLink)
        $scope.fileName = ''
	}

	$rootScope.$on('fileRead', function(_event, file) {
		var reader = new FileReader()
		reader.onload = function(e) {
			if($scope.encode) {
				$scope.encMessage = e.target.result
				$scope.compress()
			} else {
				$scope.decMessage = e.target.result
				$scope.getBinary()
			}

			$scope.$apply()
		}
		reader.readAsText(file)
		$scope.fileName = file.name.slice(0, file.name.indexOf('.'))
	})
})
.directive('openFile', function() {
	return {
		link: function(scope, element) {
			element.bind('change', function() {
				var file = element[0].files[0]
				scope.$emit('fileRead', file)
			})
		}
	}
})
