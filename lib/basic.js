// Generated by CoffeeScript 1.8.0
var async, createWidgetTable, db, insertWithObjectParam, selectMultipleRows, selectOneRow, selectWithNamedParam, selectWithNumberedParams;

async = require('async');

db = require('pg-db')();


/*
Add an event handler to log all executed SQL:
 */

db.on('execute', function(data) {
  return console.log('SQL: %j', data.sql);
});

selectOneRow = function(cb) {
  return db.queryOne('SELECT 1 AS x', function(err, row) {
    if (err) {
      return cb(err);
    }
    console.log('Row: %j', row);
    return cb();
  });
};

selectMultipleRows = function(cb) {
  return db.query('SELECT x FROM generate_series(1,5) x', function(err, rows) {
    var i, row, _i, _len;
    if (err) {
      return cb(err);
    }
    for (i = _i = 0, _len = rows.length; _i < _len; i = ++_i) {
      row = rows[i];
      console.log('Row[%s]: %j', i, row);
    }
    return cb();
  });
};

selectWithNumberedParams = function(cb) {
  return db.queryOne('SELECT $1::text AS x', ['test'], function(err, row) {
    if (err) {
      return cb(err);
    }
    console.log('Row: %j', row);
    return cb();
  });
};

selectWithNamedParam = function(cb) {
  return db.queryOne('SELECT :foo::text AS x', {
    foo: 'test'
  }, function(err, row) {
    if (err) {
      return cb(err);
    }
    console.log('Row: %j', row);
    return cb();
  });
};

createWidgetTable = function(cb) {
  var sql;
  sql = "CREATE TABLE IF NOT EXISTS widget (\n  name      text,\n  price     numeric,\n  quantity  int\n)";
  return db.update(sql, function(err, rowCount) {
    return cb(err);
  });
};

insertWithObjectParam = function(cb) {
  var sql, widget;
  widget = {
    name: 'Foobar',
    price: 123.45,
    quantity: 200
  };
  sql = "INSERT INTO widget\n(name, price, quantity)\nVALUES\n(:name, :price, :quantity)";
  return db.update(sql, widget, function(err, rowCount) {
    cb(err);
    return console.log('Updated %s rows', rowCount);
  });
};

async.series([selectOneRow, selectMultipleRows, selectWithNumberedParams, selectWithNamedParam, createWidgetTable, insertWithObjectParam], function(err) {
  if (err) {
    console.error(err);
  }
  return db.end();
});