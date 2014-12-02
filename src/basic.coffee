async = require 'async'
db = require('pg-db')()

###
Add an event handler to log all executed SQL:
###
db.on 'execute', (data) ->
  console.log 'SQL: %j', data.sql

selectOneRow = (cb) ->
  db.queryOne 'SELECT 1 AS x', (err, row) ->
    if err then return cb(err)
    console.log 'Row: %j', row
    cb()

selectMultipleRows = (cb) ->
  db.query 'SELECT x FROM generate_series(1,5) x', (err, rows) ->
    if err then return cb(err)
    for row, i in rows
      console.log 'Row[%s]: %j', i, row
    cb()

selectWithNumberedParams = (cb) ->
  db.queryOne 'SELECT $1::text AS x', ['test'], (err, row) ->
    if err then return cb(err)
    console.log 'Row: %j', row
    cb()

selectWithNamedParam = (cb) ->
  db.queryOne 'SELECT :foo::text AS x', {foo: 'test'}, (err, row) ->
    if err then return cb(err)
    console.log 'Row: %j', row
    cb()

createWidgetTable = (cb) ->
  sql =
    """
    CREATE TABLE IF NOT EXISTS widget (
      name      text,
      price     numeric,
      quantity  int
    )
    """
  db.update sql, (err, rowCount) ->
    cb(err)

insertWithObjectParam = (cb) ->
  widget =
    name: 'Foobar'
    price: 123.45
    quantity: 200
  sql =
    """
    INSERT INTO widget
    (name, price, quantity)
    VALUES
    (:name, :price, :quantity)
    """
  db.update sql, widget, (err, rowCount) ->
    cb(err)
    console.log 'Updated %s rows', rowCount

async.series [
  selectOneRow
  selectMultipleRows
  selectWithNumberedParams
  selectWithNamedParam
  createWidgetTable
  insertWithObjectParam
], (err) ->
  if err then console.error(err)
  db.end()
