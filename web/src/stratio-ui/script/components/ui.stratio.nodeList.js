'use strict';

(function($){

angular
	.module('StratioUI.components.nodeList',[])
	.directive('stNodeList', stNodeList);

stNodeList.$inject = ['TEMPLATE_URL'];
function stNodeList(TEMPLATE_URL){
	var directive = {
		restrict: 'AE',
		scope: {
			nodes: "="
		},
		templateUrl: TEMPLATE_URL('components', 'nodeList'),
		controller: controller,
		controllerAs: 'vm'
	};

	return directive;

	controller.$inject = ['$scope','$rootScope'];
	function controller($scope, $rootScope){
		var vm = this;

		var lockToogle = false;
		var lastHeaderSize = 0;

		vm.openedPanel = false;
		vm.preventToggle = preventToggle;
		vm.togglePanel = togglePanel;

		initWindowCloser();
		initOnHeaderResize();
		initOnResize();

		function togglePanel(force){
			$rootScope.$broadcast('force-on-header-resize');
			var isForced = typeof force == 'boolean';

			if(lockToogle){
				lockToogle = false;
				return;
			}
			if(!isForced)
				vm.preventToggle();
			vm.openedPanel = isForced ? force : !vm.openedPanel;

			if($rootScope.$$phase == null)
				$scope.$apply();
		}

		function preventToggle(){
			lockToogle = true;
		}

		function initWindowCloser(){
			$(window).click(function(){
				vm.togglePanel(false);
			});
		}
		function initOnResize(){
			$(window).resize(function(){
				vm.openedPanel = false;
				updateNodesPanelHeight();
			});
		}
		function initOnHeaderResize(){
			$scope.$on('on-header-resize', function(event, size){
				$('.node-panel-window').css('top', size + 'px');
			});
			$scope.$on('on-header-resize', function(event, size){
				lastHeaderSize = size;
				updateNodesPanelHeight();
			});
		}

		function updateNodesPanelHeight(){
			$('.node-panel-window .all-nodes-cont').css('height', ($(window).height() - lastHeaderSize - 50 - 10 - 35) + 'px');
		}

	}
}

})(jQuery);
