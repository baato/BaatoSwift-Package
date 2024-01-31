# Baato Swift Package

<div style="max-width:600px;">

The Baato Swift package makes it easy to integrate the [Baato](https://baato.io) API into existing iOS projects.

This package is available as a Swift Package Manager. To integrate BaatoSwift into your project, for more Please check this [Doc](https://docs.baato.io/#/)

### Usage examples

<div style="max-width:60px; margin-top:30px; ">

#### Baato Swift Configuration 

<pre><code class="language-swift">// Initialize Baato with your key
 BaatoSwift.configure(configure: Configuration(mode: .live, key: "<-YOUR-KEY->"))
</code></pre>


Helper methods in BaatoSwift make it easy to perform API requests to Baato.

<div style="max-width:600px; margin-top:30px; ">


#### Search API

the `BaatoSwift.location.search` method can be used to make requests to the Search API.

</div>

<pre><code class="language-swift">
 let res = BaatoSwift.location.search(query: "s", limit: 10, type: "town")
</code></pre>


<div style="max-width:600px; margin-top:30px; ">

#### Reverse Search API

the `BaatoSwift.location.reverseGeocode` method can be used to make requests to the Reverse Search API.

</div>

<pre><code class="language-swift">
  BaatoSwift.location.reverseGeocode(coordinate: CLLocationCoordinate2D(latitude: 27.70446921370009, longitude: 85.32051086425783))
</code></pre>


#### Places API

the `BaatoSwift.location.placeDetails` method can be used to make requests to the Places API.

</div>

<pre><code class="language-swift">
  let res = BaatoSwift.location.placeDetails(placeId: 102235)
</code></pre>

#### Directions API

the `BaatoSwift.navigation.directions` method can be used to make requests to the Directions API.

</div>

<pre><code class="language-swift">
BaatoSwift.navigation.directions(points: points, mode: BaatoNavigationMode.car, isInstructionEnable: true)
</code></pre>

#### Mapbox directions API

the `BaatoSwift.navigation.mapBoxDirections` method can be used to make requests to the Directions API for consuming mapbox direction API.

</div>

<pre><code class="language-swift">
  BaatoSwift.navigation.mapBoxDirections(startPoint:  CLLocationCoordinate2D(latitude: 27.724316366064567, longitude: 85.33965110778809), endPoint:  CLLocationCoordinate2D(latitude: 27.7418, longitude: 85.3479), mode: .car)
</code></pre>
