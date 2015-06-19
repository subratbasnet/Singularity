Helpers = require '../utils/helpers'  
EmptyTableMsg = require '../lib/EmptyTableMsg'
Table = ReactBootstrap.Table


StarredRequestsTable = React.createClass
  
  displayName: 'starredRequestsTable'

  ##
  ## Default State/Props
  ##
  propTypes:
    sortStarredRequests: React.PropTypes.func.isRequired
    unstar: React.PropTypes.func.isRequired

  getInitialState: ->
    return{
      sortedAttribute: ''
    }

  getDefaultProps: ->
    starredRequests: []

  ##
  ## Event Handlers
  ##
  handleUnstar: (e) ->
    id = $(e.currentTarget).data('id')
    @props.unstar id

  handleSort: (e) ->
    attribute = $(e.currentTarget).data('sort-attribute')
    @setState({ sortedAttribute: attribute })
    @props.sortStarredRequests attribute

  ##
  ## Build Table
  ##
  render: ->

    ##
    ## Helper variables/Fns
    ##
    attribute =
      id: 'request.id'
      timestamp: 'requestDeployState.activeDeploy.timestamp'
      user: 'requestDeployState.activeDeploy.user'
      instances: 'request.Instances'

    arrowDirection = "glyphicon glyphicon-chevron-#{if @props.data.sortedAsc then 'up' else 'down' }"
    
    sortDirection = (attr) =>
      if @state.sortedAttribute is attr then arrowDirection else ''

    if @props.data.starredRequests.length is 0
      return <EmptyTableMsg msg='No starred Requests' />      

    tbody = @props.data.starredRequests.map (request) =>
      
      link = "#{config.appRoot}/request/#{request.id}"

      return(
        <tr key={request.id}>
          <td>
            <a className="star" onClick={@handleUnstar} data-id={request.id} data-starred="true">
                <span className="glyphicon glyphicon-star"></span>
            </a>
          </td>
          <td>
            <a href={link}>
                { request.id }
            </a>
          </td>
          <td className="hidden-xs" data-value="">
            <span title="">
                { Helpers.timestampFromNow(request.requestDeployState.activeDeploy?.timestamp) }
            </span>
          </td>
          <td className="visible-lg visible-xl">
            { Helpers.usernameFromEmail(request.requestDeployState.activeDeploy?.user) }
          </td>
          <td className="visible-lg visible-xl">
            { request.instances }
          </td>
        </tr>
      )

    return (
      <Table striped className="table-staged">
        <thead>
          <tr>
            <th data-sortable="false"></th>
            <th onClick={@handleSort} data-sorted={@state.sortedAttribute is attribute.id} data-sort-attribute={attribute.id}>
              Request
              <span className={ sortDirection(attribute.id) }></span>
            </th>
            <th onClick={@handleSort} data-sorted={@state.sortedAttribute is attribute.timestamp} data-sort-attribute={attribute.timestamp} className="hidden-xs">
              Requested 
              <span className={ sortDirection(attribute.timestamp) }></span>
            </th>
            <th onClick={@handleSort} data-sorted={@state.sortedAttribute is attribute.user} data-sort-attribute={attribute.user} className="visible-lg visible-xl">
              Deploy user
              <span className={ sortDirection(attribute.user) }></span>
            </th>
            <th onClick={@handleSort} data-sorted={@state.sortedAttribute is attribute.instances} data-sort-attribute={attribute.instances} className="visible-lg visible-xl">
              Instances 
              <span className={ sortDirection(attribute.instances) }></span>
            </th>
          </tr>
        </thead>
        <tbody>
          {tbody}
        </tbody>
      </Table>
    )

module.exports = StarredRequestsTable