/* parse.js v1.0.0 | Copyright (C) 2015, StrumaSoft | MIT licensed */


/*
  * multiply string
  * 
  * str - string to multiply
  * n - number of times to multiply
  *
  */
function multiplyString (str, n) {
  var s = ""

  for (var i = 0; i < n; i++) {
    s += str
  }

  return s
}


/*
  * transform template
  * 
  * text - text to be parsed
  * data - table of data
  * delimiter - {open: "{{", close: "}}", preserve: false}
  * nestedCycles - the number of nested cycles
  * iterators - table of iterators
  * nestedConditions - the number of nested conditions
  * 
  * nested cycles/conditions must have multiple #/? depending from the layer
  * 
  * 
  * REPLACE:
  * 
  * {{amount}} 
  * 
  * 
  * CYCLE:
  * 
  * {{# array[i]
  * }}#
  * 
  * cycle iterators must have different names
  * 
  * 
  * CONDITION:
  * 
  * {{? age > 10 || ( name == "ivan" )
  * }}?
  * 
  * 
  * call global condition like 'isEmpty', but prepend internale references with 'data.' 
  * {{?@ !isEmpty(data.info) 
  * }}?
  *
  *
  * always put space before property name
  * 
  */
function transform (text, data, delimiter, nestedCycles, iterators, nestedConditions) {
  var substrings = []

  var iteratorIndex = 0
  do {
    var startDelimiterIndex = text.indexOf(delimiter.open, iteratorIndex)
    if (startDelimiterIndex >= 0) {
      if (delimiter.preserve) {
        substrings.push(text.substring(iteratorIndex, startDelimiterIndex + delimiter.open.length))
      } else {
        substrings.push(text.substring(iteratorIndex, startDelimiterIndex))
      }

      if (text.charAt(startDelimiterIndex + delimiter.open.length + nestedCycles) == "#") { // cycle
        var startExpressionIndex = startDelimiterIndex + delimiter.open.length + nestedCycles + 1 // one more because #

        // find array name and index name
        // array[i]
        var arrayExpressionEndIndex = text.indexOf("\n", startExpressionIndex)
        var arrayExpression = text.substring(startExpressionIndex, arrayExpressionEndIndex)

        var arrayStartBracketIndex = arrayExpression.lastIndexOf("[")
        var arrayEndBracketIndex = arrayExpression.lastIndexOf("]")

        var arrayName = arrayExpression.substring(0, arrayStartBracketIndex)
        var indexName = arrayExpression.substring(arrayStartBracketIndex + 1, arrayEndBracketIndex)

        // find element that will be repeated
        var endDelimiter = delimiter.close + "#" + multiplyString("#", nestedCycles)
        var endDelimiterIndex = text.indexOf(endDelimiter, arrayExpressionEndIndex + 1)
        while (text.charAt(endDelimiterIndex + endDelimiter.length) == "#") {
          endDelimiterIndex = text.indexOf(endDelimiter, endDelimiterIndex + 1)
        }

        // replace iterators
        var transformedArrayName = transform(arrayName.trim(), iterators, {open: "[", close: "]", preserve: true}, 0, {}, 0)

        // evaluate array
        var evaluationExpresion = "data." + transformedArrayName
        var evaluation = []
        try {
          evaluation = eval(evaluationExpresion)
        } catch (err) {
          console.log(err + " ==> " + evaluationExpresion)
        }

        var array = evaluation
        if (array instanceof Array && array.length > 0) { // do not iterate over non-existing or empty arrays
          var element = text.substring(arrayExpressionEndIndex + 1, endDelimiterIndex)
          for (var i = 0; i < array.length; i++) {
            iterators[indexName.trim()] = i
            substrings.push(transform(element, data, delimiter, nestedCycles + 1, iterators, nestedConditions))
          }
        }

        iteratorIndex = endDelimiterIndex + delimiter.close.length + nestedCycles + 1 // one more because #
      } else if (text.charAt(startDelimiterIndex + delimiter.open.length + nestedConditions) == "?") { // condition
        var startExpressionIndex = startDelimiterIndex + delimiter.open.length + nestedConditions + 1 // one more because ?

        // find conditional expression
        var conditionalExpressionEndIndex = text.indexOf("\n", startExpressionIndex)
        var conditionalExpression = text.substring(startExpressionIndex, conditionalExpressionEndIndex) // do not trim; always put space before propertyName

        // find element that will be conditioned
        var endDelimiter = delimiter.close + "?" + multiplyString("?", nestedConditions)
        var endDelimiterIndex = text.indexOf(endDelimiter, conditionalExpressionEndIndex + 1)
        while (text.charAt(endDelimiterIndex + endDelimiter.length) == "?") {
          endDelimiterIndex = text.indexOf(endDelimiter, endDelimiterIndex + 1)
        }

        var transformedConditionalExpression
        if (conditionalExpression.indexOf("@") == 0) { // @ expression
          transformedConditionalExpression = conditionalExpression.substring(1)
        } else {    
          // prepend properties with 'data.'
          transformedConditionalExpression = ""
          var regexIndex = 0
          var regex = /\s[A-Za-z]+/g;
          while ((match = regex.exec(conditionalExpression)) != null) {
            transformedConditionalExpression += conditionalExpression.substring(regexIndex, match.index + 1) + "data."
            regexIndex = match.index + 1
          }
          transformedConditionalExpression += conditionalExpression.substring(regexIndex, conditionalExpression.length)
        }

        // replace iterators
        transformedConditionalExpression = transform(transformedConditionalExpression.trim(), iterators, {open: "[", close: "]", preserve: true}, 0, {}, 0)

        // evaluate condition
        var evaluationExpresion = transformedConditionalExpression
        var evaluation = false
        try {
          evaluation = eval(evaluationExpresion)
        } catch (err) {
          console.log(err + " ==> " + evaluationExpresion)
        }

        if (evaluation) {
          var element = text.substring(conditionalExpressionEndIndex + 1, endDelimiterIndex)
          substrings.push(transform(element, data, delimiter, nestedCycles, iterators, nestedConditions + 1))
        }

        iteratorIndex = endDelimiterIndex + delimiter.close.length + nestedConditions + 1 // one more because ?
      } else { // replace
        var startExpressionIndex = startDelimiterIndex + delimiter.open.length
        var endDelimiterIndex = text.indexOf(delimiter.close, startExpressionIndex)

        var propertyName = text.substring(startExpressionIndex, endDelimiterIndex)

        if (isNaN(propertyName)) {
          var transformedPropertyName = transform(propertyName.trim(), iterators, {open: "[", close: "]", preserve: true}, 0, {}, 0)

          var evaluationExpresion
          if (transformedPropertyName.indexOf("@") == 0) { // @ expression
            evaluationExpresion = transformedPropertyName.substring(1)
          } else {
            evaluationExpresion = "data." + transformedPropertyName
          }

          var evaluation = ""
          try {
            evaluation = eval(evaluationExpresion)
          } catch (err) {
            console.log(err + " ==> " + evaluationExpresion)
          }

          substrings.push(evaluation)
        } else {
          substrings.push(propertyName.trim())
        }

        if (delimiter.preserve) {
          iteratorIndex = endDelimiterIndex
        } else {
          iteratorIndex = endDelimiterIndex + delimiter.close.length
        }
      }
    } else {
      substrings.push(text.substring(iteratorIndex, text.length))
    }
  } while (startDelimiterIndex >= 0)

  // concat substrings
  return substrings.join("")
}


/*
  * multi line string
  * 
  * f - multi line string function
  *
  */
function multilineString (f) {
  //return f.toString().slice(15,-3) // (14,-3) without ! // (15,-3) with !
  return f.toString().replace(/^[^\/]+\/\*!?/, '').replace(/\*\/[^\/]+$/, '')
}


/*
  * parse template
  * 
  * x - multi line string function OR text to be parsed
  * data - table of data
  * 
  */
function parse(x, data) {
  var text
  if (typeof x === "function") {
    text = multilineString(x)
  } else {
    text = x
  }

  return transform(text, data, {open: "{{", close: "}}", preserve: false}, 0, {}, 0)
}



/*
  Copyright (C) 2015, StrumaSoft

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/