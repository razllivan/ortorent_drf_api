from django.urls import include, path
from rest_framework.routers import DefaultRouter

from test_app.views import TestList

app_name = 'test_app'

router = DefaultRouter()
router.register(r'test', TestList)

urlpatterns = [
    path('', include(router.urls)),
]
