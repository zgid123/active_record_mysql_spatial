# frozen_string_literal: true

shared_context :spatial_data do
  let!(:point_params) do
    { x: 1, y: 2 }
  end

  let!(:point_array_params) do
    [1, 2]
  end

  let!(:sql_point) do
    'POINT (1.0 2.0)'
  end

  let!(:raw_point) do
    "\x00\x00\x00\x00\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\xF0?\x00\x00\x00\x00\x00\x00\x00@"
  end

  let!(:point_geometry_type) do
    RGeo::Feature::Point
  end

  let!(:linestring_params) do
    {
      coordinates: [
        { x: 1, y: 2 },
        { x: 2, y: 3 }
      ]
    }
  end

  let!(:linestring_array_params) do
    {
      coordinates: [
        [1, 2],
        [2, 3]
      ]
    }
  end

  let!(:sql_linestring) do
    'LINESTRING (1.0 2.0, 2.0 3.0)'
  end

  let!(:raw_linestring) do
    "\x00\x00\x00\x00\x01\x02\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\xF0?\x00\x00\x00\x00\x00\x00\x00@\x00\x00\x00\x00\x00\x00\x00@\x00\x00\x00\x00\x00\x00\b@"
  end

  let!(:linestring_geometry_type) do
    RGeo::Feature::LineString
  end

  let!(:multipoint_params) do
    {
      coordinates: [
        { x: 1, y: 2 },
        { x: 2, y: 3 }
      ]
    }
  end

  let!(:multipoint_array_params) do
    {
      coordinates: [
        [1, 2],
        [2, 3]
      ]
    }
  end

  let!(:sql_multipoint) do
    'MULTIPOINT ((1.0 2.0), (2.0 3.0))'
  end

  let!(:raw_multipoint) do
    "\x00\x00\x00\x00\x01\x04\x00\x00\x00\x02\x00\x00\x00\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\xF0?\x00\x00\x00\x00\x00\x00\x00@\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00@\x00\x00\x00\x00\x00\x00\b@"
  end

  let!(:multipoint_geometry_type) do
    RGeo::Feature::MultiPoint
  end

  let!(:multilinestring_params) do
    {
      coordinates: [
        [
          { x: 1, y: 2 },
          { x: 2, y: 3 }
        ],
        [
          { x: 1, y: 2 },
          { x: 2, y: 3 }
        ]
      ]
    }
  end

  let!(:multilinestring_array_params) do
    {
      coordinates: [
        [
          [1, 2],
          [2, 3]
        ],
        [
          [1, 2],
          [2, 3]
        ]
      ]
    }
  end

  let!(:sql_multilinestring) do
    'MULTILINESTRING ((1.0 2.0, 2.0 3.0), (1.0 2.0, 2.0 3.0))'
  end

  let!(:raw_multilinestring) do
    "\x00\x00\x00\x00\x01\x05\x00\x00\x00\x02\x00\x00\x00\x01\x02\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\xF0?\x00\x00\x00\x00\x00\x00\x00@\x00\x00\x00\x00\x00\x00\x00@\x00\x00\x00\x00\x00\x00\b@\x01\x02\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\xF0?\x00\x00\x00\x00\x00\x00\x00@\x00\x00\x00\x00\x00\x00\x00@\x00\x00\x00\x00\x00\x00\b@"
  end

  let!(:multilinestring_geometry_type) do
    RGeo::Feature::MultiLineString
  end

  let!(:polygon_params) do
    {
      coordinates: [
        [
          { x: 0.0, y: 0.0 },
          { x: 10.0, y: 0.0 },
          { x: 10.0, y: 10.0 },
          { x: 0.0, y: 10.0 },
          { x: 0.0, y: 0.0 }
        ],
        [
          { x: 5.0, y: 5.0 },
          { x: 7.0, y: 5.0 },
          { x: 7.0, y: 7.0 },
          { x: 5.0, y: 7.0 },
          { x: 5.0, y: 5.0 }
        ]
      ]
    }
  end

  let!(:polygon_array_params) do
    {
      coordinates: [
        [
          [0.0, 0.0],
          [10.0, 0.0],
          [10.0, 10.0],
          [0.0, 10.0],
          [0.0, 0.0]
        ],
        [
          [5.0, 5.0],
          [7.0, 5.0],
          [7.0, 7.0],
          [5.0, 7.0],
          [5.0, 5.0]
        ]
      ]
    }
  end

  let!(:sql_polygon) do
    'POLYGON ((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0), (5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0))'
  end

  let!(:raw_polygon) do
    "\x00\x00\x00\x00\x01\x03\x00\x00\x00\x02\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x14@"
  end

  let!(:polygon_geometry_type) do
    RGeo::Feature::Polygon
  end

  let!(:multipolygon_params) do
    {
      coordinates: [
        [
          [
            { x: 0.0, y: 0.0 },
            { x: 10.0, y: 0.0 },
            { x: 10.0, y: 10.0 },
            { x: 0.0, y: 10.0 },
            { x: 0.0, y: 0.0 }
          ]
        ],
        [
          [
            { x: 5.0, y: 5.0 },
            { x: 7.0, y: 5.0 },
            { x: 7.0, y: 7.0 },
            { x: 5.0, y: 7.0 },
            { x: 5.0, y: 5.0 }
          ]
        ]
      ]
    }
  end

  let!(:multipolygon_array_params) do
    {
      coordinates: [
        [
          [
            [0.0, 0.0],
            [10.0, 0.0],
            [10.0, 10.0],
            [0.0, 10.0],
            [0.0, 0.0]
          ]
        ],
        [
          [
            [5.0, 5.0],
            [7.0, 5.0],
            [7.0, 7.0],
            [5.0, 7.0],
            [5.0, 5.0]
          ]
        ]
      ]
    }
  end

  let!(:sql_multipolygon) do
    'MULTIPOLYGON (((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0)), ((5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0)))'
  end

  let!(:raw_multipolygon) do
    "\x00\x00\x00\x00\x01\x06\x00\x00\x00\x02\x00\x00\x00\x01\x03\x00\x00\x00\x01\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00$@\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x03\x00\x00\x00\x01\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x1C@\x00\x00\x00\x00\x00\x00\x14@\x00\x00\x00\x00\x00\x00\x14@"
  end

  let!(:multipolygon_geometry_type) do
    RGeo::Feature::MultiPolygon
  end
end
