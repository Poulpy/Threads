class Equipment < ApplicationRecord
  enum category: {
    sewing:       0,
    knitting:     1,
    crochet:      2,
    tatting:      3,
    lace:         4,
    embroidery:   5,
    cross_stitch: 6,
    weaving:      7,
    macrame:      8,
    spinning:     9,
    felting:     10
  }
end
