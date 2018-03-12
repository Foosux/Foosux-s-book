# ajax

## 原生 ajax

```js
const handler = function() {
  if (this.readyState !== 4) {
    return;
  }
  if (this.status === 200) {
    resolve(this.response);
  } else {
    reject(new Error(this.statusText));
  }
}

const client = new XMLHttpRequest()
client.open("GET", url)
client.onreadystatechange = handler
client.responseType = "json"
client.setRequestHeader("Accept", "application/json")
client.send()
```

- new XMLHttpRequest()

- `.open("GET", url)`

- `.onreadystatechange`
  - readyState
  - status
  - statusText

- `.responseType`

- `.setRequestHeader("Accept", "application/json")`

- `.send()`
