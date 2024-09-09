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
position = Position.create!(pt: { x: 1, y: 2 })

position = Position.create!(pt: [1, 2])

p position.pt.x # puts x
p position.pt.y # puts y
```

## Linestring

```rb
position = Position.create!(ls: [[1, 2], [2, 3]])

p position.ls.coordinates # puts all points
p position.ls.coordinates.first.x # puts x of first point
p position.ls.coordinates.last.y # puts y of last point
```

## Multilinestring

```rb
position = Position.create!(mls: [[[1, 2], [2, 3]]])

p position.mls.items # puts all linestrings
p position.mls.items.first.coordinates.first.x # puts x of first point of first linestring
p position.mls.items.last.coordinates.last.y # puts y of last point of last linestring
```
