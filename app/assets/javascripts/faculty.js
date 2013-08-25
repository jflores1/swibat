$(document).ready(function() {
	var properties = {
    w: 650,
    h: 300,
    margin: {top: 20, right: 50, bottom: 100, left: 50},
    formatPercent: d3.format("d"),
    formatDecimal: d3.format(".2f")
  }
  
  var data = $('#graph').data('chart');;
  
  function displayDomainBarChart(properties, data, type){
    var width = properties.w - properties.margin.left - properties.margin.right,
        height = properties.h - properties.margin.top - properties.margin.bottom;
    data.forEach(function(d) {
      d.score = +d.score;
    });

    // define the x scale
    var x = d3.scale.ordinal()
      .rangeRoundBands([0, width], .1)
      .domain(data.map(function(d) { return d.name; }));    

    // define the y scale
    var y = d3.scale.linear()
        .domain([0, 4])
        .range([height, 0]);

    // define the x axis
    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    // define the y axis
    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left")
        .tickFormat(properties.formatPercent);

    // remove previous graphs, if there are any
    $('#graph').empty();

    // create the graph
    var svg = d3.select("#graph").append("svg")
        .attr("width", width + properties.margin.left + properties.margin.right)
        .attr("height", height + properties.margin.top + properties.margin.bottom)
      .append("g")
        .attr("transform", "translate(" + properties.margin.left + "," + properties.margin.top + ")");

    // create the tooltip div
    var tooltip = d3.select("body").append("div")   
      .attr("class", "d3-tooltip")               
      .style("opacity", 0);

    // append the x axis to the graph
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + (height + 10) + ")")
        .call(xAxis)
          .selectAll("text")
          .attr("transform", function(d) {
              return "rotate(-10)" 
          });         

    // append the y axis to the graph
    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")          
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Score");

    // add the data
    svg.selectAll(".bar")
        .data(data)
      .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.name); })
        .attr("width", x.rangeBand())
        .attr("y", function(d) { return y(d.score); })
        .attr("height", function(d) { return height - y(d.score); })
        .on("mouseover", showTooltip)
        .on("mouseout", function(d) {       
          tooltip.transition()        
              .duration(500)      
              .style("opacity", 0);   
        });;

    function showTooltip(d){
      tooltip.transition()        
          .duration(200)      
          .style("opacity", .9);      
      tooltip .html('Domain: ' + d.name + "<br/> Average Score: "  + d.score)  
          .style("left", (d3.event.pageX) + "px")     
          .style("top", (d3.event.pageY - 28) + "px");    
                     
    }
    
  }

  displayDomainBarChart(properties, data[0].domains, 'domain');    
 
  $('#chart-template-select').change(function(){
  	var selected =  $("#chart-template-select option:selected" );
  	var template_id = $(selected[0]).attr('value');
  	var index = findIndexByTemplateId(template_id);
  	displayDomainBarChart(properties, data[index].domains, 'domain');
  });

  function findIndexByTemplateId(template_id){
  	for(var i = 0; i < data.length; i++){
  		if ((data[i].template_id + '') == template_id){
  			return i;  		
  		}
  	}
  }

});