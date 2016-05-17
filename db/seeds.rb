class Seed
  def self.start
    seed = Seed.new

    seed.generate_companies
    seed.generate_users
    seed.generate_cities
    seed.generate_jobs
    seed.generate_users_jobs
    seed.generate_store_admin_user
    seed.generate_platform_admin_user
    seed.generate_roles
  end

  def generate_companies
    30.times do |i|
      name = Faker::Company.name + i.to_s
      company = Company.create!(name: name,
      description: Faker::Hipster.paragraph(7),
      logo: Faker::Company.logo,
      url: Faker::Internet.url(name.parameterize, ".com/"),
      size: rand(1000),
      industry: Faker::Commerce.department(1),
      approve: true)
    end
    puts "Companies was created."
  end

  def generate_users
    120.times do |i|
      first_name = Faker::Name.first_name
      user = User.create(first_name: first_name,
      last_name: Faker::Name.last_name,
      password: "password",
      email: "#{i}" + Faker::Internet.free_email(first_name))
    end

    puts "Users was created."
  end

  def generate_cities
    california_cities
    new_york_cities
    colorado_cities
    puts "Cities was created."
  end

  def generate_jobs
    50.times do |i|
      job = Job.create(title: Faker::Company.profession,
      description: Faker::Lorem.paragraph(15),
      years_of_experience: rand(1..4),
      city_id: rand(1..12),
      education: Faker::Lorem.word,
      department: Faker::Commerce.department,
      salary: rand(60000...90000),
      job_type: "fulltime",
      company_id: rand(1..30))
    end
    puts "Jobs created."
  end

  def generate_users_jobs
    status = [0, 1]

    20.times do |i|
      UsersJob.create(status: status.sample,
      resume: Faker::Hipster.paragraph,
      user_id: rand(1..120),
      job_id: rand(1..50))
    end
    puts "User jobs created."
  end

  def generate_platform_admin_user
    user = User.create(first_name: "Admin",
    last_name: "Admin",
    email: "platform@admin.com",
    password: "password")
    puts "Platform Admin Account Created"
  end

  def generate_store_admin_user
    user = User.create(first_name: "Admin",
    last_name: "Admin",
    email: "store@admin.com",
    password: "password")
    puts "Store Admin Account Created"
  end

  def generate_roles
    Role.create(name: "registered_user")
    Role.create(name: "store_admin")
    Role.create(name: "platform_admin")
    puts "Finished Generating Roles"
  end



  private
  def california_cities
    ca = ["Venice", "San Francisco", "Sacramento", "Los Angeles"]

    ca.each do |city|
      City.create(name: city, state: "CA")
    end
  end

  def new_york_cities
    ny = ["New York", "Yonkers", "Rochester", "Buffalo"]

    ny.each do |city|
      City.create(name: city, state: "NY")
    end
  end

  def colorado_cities
    co = ["Denver", "Boulder", "Littleton", "Colorado Springs"]

    co.each do |city|
      City.create(name: city, state: "CO")
    end
  end

end

Seed.start

# 1 business admins per business

# Username: andrew@turing.io
# Password: password

# 1 platform administrators
# Username: jorge@turing.io
# Password: password
