describe 'PhoneCat App', ->

  describe 'Phone list view', ->

    beforeEach ->
      browser().navigateTo('/')

    it 'should work', ->
      pause()
      expect(element('.phones li').count()).toBe(0);

