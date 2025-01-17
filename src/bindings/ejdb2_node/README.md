# EJDB2 Node.js native binding

Embeddable JSON Database engine http://ejdb.org Node.js binding.

See https://github.com/Softmotions/ejdb/blob/master/README.md

For API usage examples take a look into [/example](https://github.com/Softmotions/ejdb/tree/master/src/bindings/ejdb2_node/example) and [test.js](https://github.com/Softmotions/ejdb/tree/master/src/bindings/ejdb2_node/test.js)

```ts
import { EJDB2 } from 'ejdb2_node';

async function run() {
  const db = await EJDB2.open('example.db', { truncate: true });

  var id = await db.put('parrots', {'name': 'Bianca', 'age': 4});
  console.log(`Bianca record: ${id}`);

  id = await db.put('parrots', {'name': 'Darko', 'age': 8});
  console.log(`Darko record: ${id}`);

  const q = db.createQuery('/[age > :age]', 'parrots');

  for await (const doc of q.setNumber('age', 3).stream()) {
    console.log(`Found ${doc}`);
  }

  await db.close();
}

run();
```

## Supported platforms

* Linux x64
* OSX

## Prerequisites

* CMake >= v3.10
* Make
* gcc or clang compiler

## How build it manually

``` sh
git clone https://github.com/Softmotions/ejdb.git
cd ./ejdb
mkdir ./build && cd build
cmake .. -DBUILD_NODEJS_BINDING=ON -DCMAKE_BUILD_TYPE=Release
make
cd src/bindings/ejdb2_node/ejdb2_node
yarn pack
```