# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

equipments = [
  # Sewing
  { name: 'Machine à coudre Singer Heavy Duty', category: :sewing },
  { name: 'Surjeteuse Brother 1034D', category: :sewing },
  { name: 'Table de découpe pliable', category: :sewing },

  # Knitting
  { name: 'Machine à tricoter Brother KH-970', category: :knitting },
  { name: 'Aiguilles circulaires en bambou', category: :knitting },

  # Crochet
  { name: 'Set de crochets ergonomiques', category: :crochet },
  { name: 'Crochet tunisien', category: :crochet },

  # Tatting
  { name: 'Navette à frivolité', category: :tatting },

  # Lace
  { name: 'Coussin à dentelle aux fuseaux', category: :lace },
  { name: 'Fuseaux en bois', category: :lace },

  # Embroidery
  { name: 'Métier à broder rotatif', category: :embroidery },
  { name: 'Machine à broder Brother PE800', category: :embroidery },

  # Cross stitch
  { name: 'Tambour à broder 20cm', category: :cross_stitch },
  { name: 'Loupe éclairante pour point de croix', category: :cross_stitch },

  # Weaving
  { name: 'Métier à tisser de table', category: :weaving },
  { name: 'Navette de tissage', category: :weaving },

  # Macrame
  { name: 'Support de macramé sur pied', category: :macrame },

  # Spinning
  { name: 'Rouet à pédale', category: :spinning },
  { name: 'Fuseau à filer portatif', category: :spinning },

  # Felting
  { name: 'Aiguilles à feutrer set de 5', category: :felting },
  { name: 'Tapis de feutrage en mousse', category: :felting }
]

equipments.each do |attrs|
  Equipment.find_or_create_by!(name: attrs[:name]) do |equipment|
    equipment.category = attrs[:category]
  end
end

Rails.logger.debug "#{Equipment.count} équipements en base."

users = [
  { name: 'Paul', email: 'paul@example.com' },
  { name: 'Alice', email: 'alice@example.com' },
  { name: 'Bob', email: 'bob@example.com' }
]

users.each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |user|
    user.name = attrs[:name]
    user.auth_token = SecureRandom.uuid
  end
end

Rails.logger.debug "#{User.count} utilisateurs en base."
