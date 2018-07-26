# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(name: 'Comedies')
drama = Category.create(name: 'Dramas')

Video.create(title: 'Family Guy', description: 'a good video', small_cover_url: 'family_guy.jpg', large_cover_url: 'monk_large.jpg', category: comedy)
Video.create(title: 'Futurama', description: 'a good video', small_cover_url: 'futurama.jpg', large_cover_url: 'monk_large.jpg', category: comedy)
monk = Video.create(title: 'Monk', description: 'a good video', small_cover_url: 'monk.jpg', large_cover_url: 'monk_large.jpg', category: comedy)
Video.create(title: 'South Park', description: 'a good video', small_cover_url: 'south_park.jpg', large_cover_url: 'monk_large.jpg', category: drama)

kevin = User.create(full_name: 'Kevin Wang', password: 'password', email: 'kevin@example.com')

Review.create(user: kevin, video: monk, rating: 5, content: 'this is a good movie')
Review.create(user: kevin, video: monk, rating: 2,  content: 'this is a ok movie')