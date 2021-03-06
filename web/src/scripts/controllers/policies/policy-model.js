(function () {
  'use strict';

  /*POLICY MODEL CONTROLLER*/
  angular
    .module('webApp')
    .controller('PolicyModelCtrl', PolicyModelCtrl);

  PolicyModelCtrl.$inject = ['ModelFactory', 'PolicyModelFactory', 'ModelService'];

  function PolicyModelCtrl(ModelFactory, PolicyModelFactory, ModelService) {
    var vm = this;

    vm.init = init;
    vm.addModel = addModel;
    vm.removeModel = removeModel;
    vm.resetOutputFields = resetOutputFields;
    vm.onChangeType= onChangeType;
    vm.isLastModel = ModelService.isLastModel;
    vm.isNewModel = ModelService.isNewModel;
    vm.modelInputs = ModelFactory.getModelInputs();

    vm.init();

    function init() {
      vm.template = PolicyModelFactory.getTemplate();
      vm.policy = PolicyModelFactory.getCurrentPolicy();
      vm.model = ModelFactory.getModel();
      vm.modelError = '';
      vm.lastType = vm.template.model.types[0].name;
      if (vm.model) {
        vm.modelError = ModelFactory.getError();
        vm.modelContext = ModelFactory.getContext();
        vm.modelTypes = vm.template.model.types;
        vm.configPlaceholder = vm.template.configPlaceholder;
        vm.outputPattern = vm.template.outputPattern;
        vm.outputInputPlaceholder = vm.template.outputInputPlaceholder;
        vm.outputFieldTypes = vm.template.model.outputFieldTypes;
      }
    }

    function onChangeType(){
      switch (vm.model.type) {
        case "Morphlines":{
          vm.model.configuration = vm.template.model.morphlines.defaultConfiguration;
          console.log(vm.model.configuration);
        }
      }
    }

    function addModel() {
      vm.form.$submitted = true;
      if (vm.form.$valid && vm.model.outputFields.length != 0) {
        vm.form.$submitted = false;
        ModelService.addModel();
        ModelService.changeModelCreationPanelVisibility(false);
      } else {
        ModelFactory.setError("_GENERIC_FORM_ERROR_");
      }
    }

    function removeModel() {
      return ModelService.removeModel().then(function () {
        var order = 0;
        var modelNumber = vm.policy.transformations.length;
        if (modelNumber > 0) {
          order = vm.policy.transformations[modelNumber - 1].order + 1
        }
        vm.model = ModelFactory.resetModel(vm.template.model, order, modelNumber);
        ModelFactory.updateModelInputs(vm.policy.transformations);
      });
    }

    function resetOutputFields() {
      if (vm.model.type !== vm.lastType) {
        vm.model.outputFields = [];
        vm.lastType = vm.model.type;
      }
    }
  }
})
();
