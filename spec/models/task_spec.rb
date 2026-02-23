require "rails_helper"

RSpec.describe Task, type: :model do
  describe "validations" do
    it "requires a title" do
      task = FactoryBot.build(:task, title: nil)

      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end
  end

  describe ".todo" do
    it "returns only incomplete tasks ordered newest first" do
      older_todo = FactoryBot.create(:task, completed: false, created_at: 2.days.ago)
      newer_todo = FactoryBot.create(:task, completed: false, created_at: 1.day.ago)
      FactoryBot.create(:task, completed: true, created_at: Time.current)

      expect(Task.todo).to eq([newer_todo, older_todo])
    end
  end

  describe ".completed" do
    it "returns only completed tasks ordered newest first" do
      older_done = FactoryBot.create(:task, completed: true, created_at: 2.days.ago)
      newer_done = FactoryBot.create(:task, completed: true, created_at: 1.day.ago)
      FactoryBot.create(:task, completed: false, created_at: Time.current)

      expect(Task.completed).to eq([newer_done, older_done])
    end
  end
end
