require 'spec_helper'

feature 'Github Issue Opened' do

  given(:endpoint) { '/api/github_issue_opened.json' }

  background do
    @first_time_badge                         = FactoryGirl.create(:first_time)
    @one_github_issue_opened_badge            = FactoryGirl.create(:one_github_issue_opened)
    @twenty_five_github_issues_opened_badge   = FactoryGirl.create(:twenty_five_github_issues_opened)
  end

  given!(:user)    { FactoryGirl.create(:github_user) }
  given!(:metric)  { FactoryGirl.create(:github_issue_opened) }

  given(:valid_params) do
    { payload: GithubPayloads.issue_opened(user.github_username) }
  end

  describe 'First opened issue' do

    background { page.driver.post endpoint, valid_params }

    scenario 'User is given the First Github Issue Opened and First Timer badges' do
      visit user_path(user)
      page.should have_content @first_time_badge.description
      page.should have_content @one_github_issue_opened_badge.description # failing because badge is missing

      page.should have_content "#{metric.default_unit} All-time Score"
      page.should have_content '2 Badges'
    end
  end

end
