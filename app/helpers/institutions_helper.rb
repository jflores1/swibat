module InstitutionsHelper

	def show_map(longitude, latitude)
    result = "<a href=\"http://maps.google.com/maps?f=q&amp;source=embed&amp;hl=en&amp;geocode=&amp;q=" + 
              latitude.to_s  + "," +
              longitude.to_s  +
              "&amp;aq=&amp;sll=37.0625,-95.677068&amp;sspn=43.848534,93.076172&amp;ie=UTF8&amp;ll=" +
              latitude.to_s  + "," +
              longitude.to_s  + "&amp;spn=0.003929,0.006416&amp;z=16\" target=\"_blank\"> <img src=\"http://maps.google.com/maps/api/staticmap?center=" +
              latitude.to_s  + "," +
              longitude.to_s  + "&zoom=16&size=300x300&maptype=roadmap&markers=color:purple|" +
              latitude.to_s  + "," +
              longitude.to_s  + "&sensor=false\" class=\"venuemap\" /></a>" 
  end
end
