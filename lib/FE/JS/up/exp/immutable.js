const { fromJS, Map } = require('immutable')

const A1 = fromJS({
  name: 'Tom',
  type: 1
})

console.log(A1)   // Map { "name": "Tom", "type": 1 }
