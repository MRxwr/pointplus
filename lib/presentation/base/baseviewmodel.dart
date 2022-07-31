abstract class BaseViewModel extends BaseViewModelInputs with BaseViewModelOutputs{
  //shared variables and functions that will be used through any view model.

}
abstract class BaseViewModelInputs{
  void start();// will be called while init. of view Model
void dispoe();// will be called when viewmodel dies.
}

abstract class BaseViewModelOutputs{}