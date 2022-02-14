first_bearer = Bearer.create!(name: "First Bearer")
second_bearer = Bearer.create!(name: "Second Bearer")
third_bearer = Bearer.create!(name: "Third Bearer")

Stock.create!(name: "First Stock", bearer: first_bearer)
Stock.create!(name: "Second Stock", bearer: first_bearer)
Stock.create!(name: "Third Stock", bearer: second_bearer)
Stock.create!(name: "Fourth Stock", bearer: third_bearer)
Stock.create!(name: "Fifth Stock", bearer: third_bearer)
