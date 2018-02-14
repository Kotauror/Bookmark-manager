feature 'view links' do
  scenario 'display links' do
    visit('/')
    expect(page).to have_content "Makers Academy"
    expect(page).to have_content "Google"
    expect(page).to have_content "Evil"
  end
end
