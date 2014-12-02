async = require 'async'
db = require('pg-db')()

###
Add an event handler to log all executed SQL:
###
db.on 'execute', (data) ->
  console.log 'SQL: %j', data.sql

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

createAuditTable = (cb) ->
  sql =
    """
    CREATE TABLE IF NOT EXISTS audit (
      message     text,
      created_at  timestamptz DEFAULT now()
    )
    """
  db.update sql, (err, rowCount) ->
    cb(err)

createWidget = (widget, cb) ->
  sql =
    """
    INSERT INTO widget
    (name, price, quantity)
    VALUES
    (:name, :price, :quantity)
    """
  db.update sql, widget, (err, rowCount) ->
    console.log 'Insert count: %s rows', rowCount
    cb(err)

createAudit = (message, cb) ->
  sql =
    """
    INSERT INTO audit
    (message)
    VALUES
    (:message)
    """
  db.update sql, {message}, (err, rowCount) ->
    console.log 'Insert count: %s rows', rowCount
    cb(err)

widget =
  name: 'Foobar'
  price: 123.45
  quantity: 200

db.tx.series [
  createWidgetTable
  createAuditTable
  (cb) -> createWidget(widget, cb)
  (cb) -> createAudit('Created widget with name: ' + widget.name, cb)
], (err) ->
  if err
    console.error 'Transaction error: %s', err
  else
    console.log 'Transaction completed successfully'
  db.end()
