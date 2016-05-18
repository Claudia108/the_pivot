require 'rails_helper'

RSpec.describe UsersJob, type: :model do
  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:job) }
  end

  context "#apply_to_job" do
    it "associates user with a new record and applied status" do
      job_one, job_two = create_list(:job, 2)
      user = create(:user)
      UsersJob.create(user_id: user.id, job_id: job_one.id)
      resume_path = "#{Rails.root}/spec/support/sample_cv_of_failures.pdf"
      cover_letter_text = "Sample text."
      application = { resume: resume_path,
                      cover_letter: cover_letter_text,
                      job: job_two.id }

      expect(user.users_jobs.count).to eql(1)

      applied_user_job = UsersJob.apply_to_job(application, user)

      expect(user.users_jobs.count).to eql(2)
      expect(applied_user_job.resume).to eql(resume_path)
      expect(applied_user_job.cover_letter).to eql(cover_letter_text)
      expect(applied_user_job.status).to eql("applied")
    end
  end

  context "#update_with_application" do
    it "can find existing user_job record" do
      job = create(:job)
      user, non_existing_user = create_list(:user, 2)
      existing_user = UsersJob.create(user_id: user.id, job_id: job.id)
      existing_user_job_search = UsersJob.query_record("#{job.id}", existing_user)
      non_existing_user_job_search = UsersJob.query_record("#{job.id}", non_existing_user)

      expect(existing_user_job_search.id).to eql(1)
      expect(non_existing_user_job_search).to be nil
    end

    it "changes user with an existing record to have an applied status for job" do
      job  = create(:job)
      user = create(:user)
      user_job = UsersJob.create(user_id: user.id, job_id: job.id)
      resume_path = "#{Rails.root}/spec/support/sample_cv_of_failures.pdf"
      cover_letter_text = "Sample text."
      application = { resume: resume_path,
                      cover_letter: cover_letter_text,
                      job: "#{job.id}" }
      expect(user.users_jobs.count).to eql(1)
      expect(user_job.status).to eql("favorited")

      updated_user_job = user_job.update_with_application(application, user_job.user)
      expect(updated_user_job.resume).to eql(resume_path)
      expect(updated_user_job.cover_letter).to eql(cover_letter_text)
      expect(updated_user_job.status).to eql("applied")
    end
  end

  context "#query_for_users_jobs_with_applied_status" do
    it "can find jobs that a registered user has applied for" do
      registered_user = create(:user)
      jobs = create_list(:job, 2)
      jobs.each do |job|
        users_job_with_resume(registered_user, job)
      end

      users_jobs = UsersJob.query_for_user_applied_jobs(registered_user)

      expect(users_jobs).to eql(jobs)
    end
  end

  context "#current_users_favorited_jobs" do
    it "finds all current_user's favorited jobs" do
      job1, job2, job3 = create_list(:job, 3)
      user = create(:user)
      user.roles << Role.create(name: "registered_user")
      UsersJob.create(user_id: user.id, job_id: job1.id, status: 0)
      UsersJob.create(user_id: user.id, job_id: job2.id, status: 1)
      UsersJob.create(user_id: user.id, job_id: job3.id, status: 0)


      users_jobs = UsersJob.current_users_favorited_jobs(user)
      expect(users_jobs).to include(job1)
      expect(users_jobs).to include(job3)
    end
  end

  context "status helper methods" do
    it "shows status favorited" do
      users_job_one, users_job_two, users_job_three = create_list(:users_job, 3)
      users_job_two.favorited!

      expect(UsersJob.favorited).to include(users_job_two)
    end

    it "shows status applied" do
      users_job_one, users_job_two, users_job_three = create_list(:users_job, 3)
      users_job_two.applied!

      expect(UsersJob.applied).to include(users_job_two)
    end
  end
end
