package com.stratio.sparta.testsAT.automated.gui.inputs;

import org.testng.annotations.Factory;
import org.testng.annotations.Test;

import com.stratio.cucumber.testng.CucumberRunner;
import com.stratio.data.BrowsersDataProvider;
import com.stratio.sparta.testsAT.utils.BaseTest;

import cucumber.api.CucumberOptions;

@CucumberOptions(features = { "src/test/resources/features/automated/gui/inputs/checkElementsInputs.feature" })
public class CheckElements extends BaseTest {
    
    @Factory(enabled = false, dataProviderClass = BrowsersDataProvider.class, dataProvider = "availableUniqueBrowsers")
    public CheckElements(String browser) {
	this.browser = browser;
    }

    @Test(enabled = true, groups = {"web"})
    public void checkElementsTest() throws Exception {
        new CucumberRunner(this.getClass()).runCukes();
    }
}