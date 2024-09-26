ActiveRecord extension for MySQL Spatial Data.

# Installation

```sh
gem 'active_record_mysql_spatial'
```

# Migration

This extension provides some data type methods for ActiveRecord migration and also register those types to the schema.

```rb
# frozen_string_literal: true

class CreatePositions < ActiveRecord::Migration[7.2]
  def change
    create_table :positions do |t|
      t.linestring :ls
      t.multilinestring :mls
      t.point :pt

      t.column :tls, :linestring
      t.column :tmls, :multilinestring
      t.column :tpt, :point

      t.timestamps
    end
  end
end
```

Without this extension, even you use `t.column` to define the column for the table, you will receive the error message in the `schema.rb`

```rb
# Could not dump table "positions" because of following StandardError
#   Unknown type 'linestring' for column 'tls'
```

# Usage

## Point

```rb
position = Position.create!(pt: { x: 1, y: 2 }) # or can use { coordinate: { x: 1, y: 2 } }

position = Position.create!(pt: [1, 2])

p position.pt.x # puts x
p position.pt.y # puts y
```

## Linestring

```rb
position = Position.create!(ls: { coordinates: [[1, 2], [2, 3]] }) # or can use [{ x: 1, y: 2 }, { x: 2, y: 3 }]

p position.ls.items # puts all points
p position.ls.items.first.x # puts x of first point
p position.ls.items.last.y # puts y of last point
```

## Multilinestring

```rb
position = Position.create!(mls: { coordinates: [[[1, 2], [2, 3]]] }) # or can use [[{ x: 1, y: 2 }, { x: 2, y: 3 }]]

p position.mls.items # puts all linestrings
p position.mls.items.first.items.first.x # puts x of first point of first linestring
p position.mls.items.last.items.last.y # puts y of last point of last linestring
```

## Multipoint

```rb
position = Position.create!(mpt: { coordinates: [[1, 2], [2, 3]] }) # or can use [{ x: 1, y: 2 }, { x: 2, y: 3 }]

p position.mls.items # puts all points
p position.mls.items.first.x # puts x of first point
p position.mls.items.last.y # puts y of last point
```

## Polygon

```rb
position = Position.create!(plg: { coordinates: [[[0.0, 0.0], [10.0, 0.0], [10.0, 10.0], [0.0, 10.0], [0.0, 0.0]], [[5.0, 5.0], [7.0, 5.0], [7.0, 7.0], [5.0, 7.0], [5.0, 5.0]]] }) # or can use [[{ x: 0.0, y: 0.0 }, { x: 10.0, y: 0.0 }, { x: 10.0, y: 10.0 }, { x: 0.0, y: 10.0 }, { x: 0.0, y: 0.0 }], [{ x: 5.0, y: 5.0 }, { x: 7.0, y: 5.0 }, { x: 7.0, y: 7.0 }, { x: 5.0, y: 7.0 }, { x: 5.0, y: 5.0 }]]

p position.plg.items # puts all linestring
p position.plg.items.first.items.first.x # puts x of first point of first linestring
p position.plg.items.last.items.last.y # puts y of last point of last linestring
```

## Multipolygon

```rb
position = Position.create!(mplg: { coordinates: [[[[0.0, 0.0], [10.0, 0.0], [10.0, 10.0], [0.0, 10.0], [0.0, 0.0]]], [[[5.0, 5.0], [7.0, 5.0], [7.0, 7.0], [5.0, 7.0], [5.0, 5.0]]]] }) # or can use [[[{ x: 0.0, y: 0.0 }, { x: 10.0,y:  0.0 }, { x: 10.0, y: 10.0 }, { x: 0.0, y: 10.0 }, { x: 0.0, y: 0.0 }]], [[{ x: 5.0, y: 5.0 }, { x: 7.0, y: 5.0 }, { x: 7.0, y: 7.0 }, { x: 5.0, y: 7.0 }, { x: 5.0, y: 5.0 }]]]

p position.mplg.items # puts all polygons
p position.mplg.items.first.items # puts all linestrings of first polygon
p position.mplg.items.last.items # puts all linestrings of last polygon
```

## Geometrycollection

One geometrycollection may contains point, linestring, multilinestring, multipoint, polygon, multipolygon and geometrycollection

```rb
params = {
  geometries: [
    { type: :point, coordinates: { x: 1, y: 2 } },
    { type: :linestring, coordinates: [{ x: 1, y: 2 }, { x: 2, y: 3 }] },
    { type: :multilinestring, coordinates: [[{ x: 1, y: 2 }, { x: 2, y: 3 }], [{ x: 1, y: 2 }, { x: 2, y: 3 }]] },
    { type: :multipoint, coordinates: [{ x: 1, y: 2 }, { x: 2, y: 3 }] },
    { type: :polygon, coordinates: [[{ x: 0.0, y: 0.0 }, { x: 10.0, y: 0.0 }, { x: 10.0, y: 10.0 }, { x: 0.0, y: 10.0 }, { x: 0.0, y: 0.0 }], [{ x: 5.0, y: 5.0 }, { x: 7.0, y: 5.0 }, { x: 7.0, y: 7.0 }, { x: 5.0, y: 7.0 }, { x: 5.0, y: 5.0 }]] },
    { type: :multipolygon, coordinates: [[[{ x: 0.0, y: 0.0 }, { x: 10.0, y: 0.0 }, { x: 10.0, y: 10.0 }, { x: 0.0, y: 10.0 }, { x: 0.0, y: 0.0 }]], [[{ x: 5.0, y: 5.0 }, { x: 7.0, y: 5.0 }, { x: 7.0, y: 7.0 }, { x: 5.0, y: 7.0 }, { x: 5.0, y: 5.0 }]]] }
  ]
}

position = Position.create!(geomcol: params)

p position.geomcol.items # puts all geometries
```

# Custom result class

In your business, you may need to use spatial data for a purpose. To load data and map to the semantic data for your business, create a class and override the method `cast_value`.

```rb
class YourClass < ActiveRecordMysqlSpatial::ActiveRecord::MySQL::Linestring
  attr_reader :sum_x, :sum_y

  private

  def cast_value(value)
    super

    @sum_x, @sum_y = @coordinates.reduce([0, 0]) do |sum, point|
      sum[0] += point.x.to_i
      sum[1] += point.y.to_i
      sum
    end

    self
  end
end

# models/position.rb
class Position < ApplicationRecord
  include ActiveRecordMysqlSpatial::ActsAsSpatial

  acts_as_linestring :ls, serializer: YourClass
end
```
